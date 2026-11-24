// config.js
const SUPABASE_URL = 'https://rqzothjsbfcgpkunjuim.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_r-J3P362nnPDAMyQbLSrjA_iwW_OUvi';

// Initialize Supabase client
const { createClient } = supabase;
const supabaseClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);