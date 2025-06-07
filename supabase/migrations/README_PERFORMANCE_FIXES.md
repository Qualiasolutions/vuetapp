# Supabase Performance Fixes

This document explains the performance improvements implemented in the `20250701000000_fix_performance_warnings.sql` migration.

## Issues Fixed

### 1. Auth RLS Initialization Plan Performance

**Problem**: The database linter detected that calls to `auth.uid()` in Row Level Security (RLS) policies were being re-evaluated for each row. This creates significant overhead when querying tables with many rows.

**Solution**: Modified all RLS policies to use `(SELECT auth.uid())` instead of directly calling `auth.uid()`. This ensures the function is evaluated only once for the entire query rather than for each row.

Affected tables:
- `student_entities`
- `school_entities`
- `school_term_entities` 
- `academic_plan_entities`
- `school_break_entities`
- `birthdays`

### 2. Multiple Permissive Policies

**Problem**: Several tables had multiple permissive RLS policies for the same role and action. Since all permissive policies are executed for every query, this creates unnecessary overhead.

**Solution**: Consolidated redundant policies into a single policy per action type (SELECT, INSERT, UPDATE, DELETE) where appropriate.

Affected tables:
- `entity_categories`
- `school_entities`
- `school_term_entities`
- `student_entities`

## How to Apply

You can apply this migration using:

```bash
supabase migration up --file 20250701000000_fix_performance_warnings.sql
```

Or run the helper script:

```bash
node scripts/apply_performance_fixes.js
```

## Expected Benefits

- Improved query performance, especially for tables with many rows
- Reduced database CPU usage
- More efficient execution of RLS policies
- Cleaner policy structure 