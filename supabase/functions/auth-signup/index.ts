// @ts-ignore - Supabase client import
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { corsHeaders } from '../_shared/cors.ts';

// @ts-ignore - Deno is available in edge runtime
declare var Deno: any;

console.log("Auth signup function loaded")

Deno.serve(async (req: Request) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { email, password, firstName, lastName, accountType, professionalCategory } = await req.json()

    // Validate input
    if (!email || !password || !firstName || !lastName || !accountType) {
      return new Response(
        JSON.stringify({ 
          error: 'Missing required fields',
          code: 'VALIDATION_ERROR'
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    // Create Supabase client with service role key
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    // Step 1: Create auth user
    const { data: authData, error: authError } = await supabaseClient.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    })

    if (authError) {
      console.error('Auth user creation failed:', authError)
      return new Response(
        JSON.stringify({ 
          error: authError.message,
          code: 'AUTH_ERROR'
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    const userId = authData.user.id

    // Step 2: Create profile with retry logic
    let profileCreated = false
    let attempts = 0
    const maxRetries = 3

    while (!profileCreated && attempts < maxRetries) {
      attempts++
      
      try {
        // Add delay before retry (except first attempt)
        if (attempts > 1) {
          const delay = Math.pow(2, attempts - 1) * 500 // 500ms, 1s, 2s
          await new Promise(resolve => setTimeout(resolve, delay))
        }

        console.log(`Creating profile attempt ${attempts}/${maxRetries} for user ${userId}`)

        const { error: profileError } = await supabaseClient
          .from('profiles')
          .insert([
            {
              id: userId,
              email,
              first_name: firstName,
              last_name: lastName,
              account_type: accountType,
              professional_category_id: professionalCategory || null,
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            }
          ])

        if (profileError) {
          console.error(`Profile creation attempt ${attempts} failed:`, profileError)
          
          // Check if it's a foreign key constraint error (auth user not ready)
          if (profileError.message?.includes('profiles_id_fkey') || 
              profileError.code === 'PGRST301') {
            if (attempts < maxRetries) {
              console.log('Foreign key constraint error - retrying...')
              continue
            }
          }
          
          throw profileError
        }

        profileCreated = true
        console.log(`Profile created successfully for user ${userId}`)

      } catch (error) {
        console.error(`Profile creation attempt ${attempts} error:`, error)
        
        if (attempts >= maxRetries) {
          // Cleanup: delete the auth user if profile creation failed
          try {
            await supabaseClient.auth.admin.deleteUser(userId)
            console.log('Cleaned up auth user after profile creation failure')
          } catch (cleanupError) {
            console.error('Failed to cleanup auth user:', cleanupError)
          }
          
          return new Response(
            JSON.stringify({ 
              error: `Profile creation failed after ${maxRetries} attempts: ${error.message}`,
              code: 'PROFILE_CREATION_ERROR'
            }),
            {
              status: 500,
              headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            }
          )
        }
      }
    }

    // Success response
    return new Response(
      JSON.stringify({ 
        success: true,
        user: {
          id: userId,
          email: authData.user.email,
        },
        message: 'User registered successfully'
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )

  } catch (error) {
    console.error('Signup function error:', error)
    return new Response(
      JSON.stringify({ 
        error: 'Internal server error',
        code: 'INTERNAL_ERROR',
        details: error.message
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})
