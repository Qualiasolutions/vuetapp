/// <reference types="https://esm.sh/@supabase/functions-js/src/edge-runtime.d.ts" />
import { corsHeaders } from '../_shared/cors.ts'

console.log("OpenAI chat function loaded")

Deno.serve(async (req: Request) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { messages, userContext } = await req.json()

    // Validate input
    if (!messages || !Array.isArray(messages)) {
      return new Response(
        JSON.stringify({ 
          error: 'Messages array is required',
          code: 'VALIDATION_ERROR'
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    // Get OpenAI API key from environment
    const openaiApiKey = Deno.env.get('OPENAI_API_KEY')
    if (!openaiApiKey) {
      console.error('OPENAI_API_KEY not configured')
      return new Response(
        JSON.stringify({ 
          error: 'OpenAI API key not configured',
          code: 'CONFIGURATION_ERROR'
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    // Prepare system message with user context
    const systemMessage = {
      role: 'system',
      content: `You are LANA (Life Assistant & Nurturing Advisor), a helpful AI assistant integrated into the Vuet productivity app. 
      ${userContext ? `User context: ${JSON.stringify(userContext)}` : ''}
      
      Help users with:
      - Task management and planning
      - Schedule organization
      - Productivity tips
      - Goal setting and tracking
      
      Be concise, friendly, and actionable in your responses.`
    }

    // Prepare request body for OpenAI
    const requestBody = {
      model: 'gpt-3.5-turbo',
      messages: [systemMessage, ...messages],
      max_tokens: 500,
      temperature: 0.7,
    }

    console.log('Calling OpenAI API...')

    // Call OpenAI API with timeout
    const controller = new AbortController()
    const timeout = setTimeout(() => controller.abort(), 30000) // 30 second timeout

    try {
      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${openaiApiKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody),
        signal: controller.signal
      })

      clearTimeout(timeout)

      if (!response.ok) {
        const errorData = await response.json()
        console.error('OpenAI API Error:', response.status, errorData)
        
        return new Response(
          JSON.stringify({ 
            error: `OpenAI API error: ${errorData.error?.message || 'Unknown error'}`,
            code: 'OPENAI_ERROR'
          }),
          {
            status: response.status,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' }
          }
        )
      }

      const data = await response.json()
      const message = data.choices[0]?.message?.content || 'Sorry, I couldn\'t generate a response.'

      return new Response(
        JSON.stringify({ 
          success: true,
          message: message,
          model: data.model,
          usage: data.usage
        }),
        {
          status: 200,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )

    } catch (error) {
      clearTimeout(timeout)
      
      if (error.name === 'AbortError') {
        console.error('OpenAI API request timed out')
        return new Response(
          JSON.stringify({ 
            error: 'Request timed out',
            code: 'TIMEOUT_ERROR'
          }),
          {
            status: 408,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' }
          }
        )
      }
      
      throw error
    }

  } catch (error) {
    console.error('OpenAI chat function error:', error)
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
