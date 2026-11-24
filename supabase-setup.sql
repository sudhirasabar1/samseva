-- 1. Create the Applications Table
CREATE TABLE public.applications (
    id UUID DEFAULT extensions.uuid_generate_v4() PRIMARY KEY,
    application_id TEXT NOT NULL UNIQUE,
    customer_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    service TEXT NOT NULL,
    photo_path TEXT,
    pdf_path TEXT,
    instructions TEXT,
    status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processing', 'Completed', 'Rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies for Database
-- Allow anyone (anonymous) to INSERT an application
CREATE POLICY "Allow anonymous inserts" ON public.applications
    FOR INSERT WITH CHECK (true);

-- Allow only authenticated admins to SELECT applications
CREATE POLICY "Allow authenticated select" ON public.applications
    FOR SELECT USING (auth.role() = 'authenticated');

-- Allow only authenticated admins to UPDATE applications
CREATE POLICY "Allow authenticated update" ON public.applications
    FOR UPDATE USING (auth.role() = 'authenticated');

-- 4. Storage Setup
-- Create a private bucket for customer documents
INSERT INTO storage.buckets (id, name, public) 
VALUES ('customer-documents', 'customer-documents', false);

-- 5. Storage RLS Policies
-- Allow anonymous users to upload files to the bucket
CREATE POLICY "Allow anonymous uploads" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'customer-documents');

-- Allow only authenticated admins to view/download files
CREATE POLICY "Allow authenticated downloads" ON storage.objects
    FOR SELECT USING (bucket_id = 'customer-documents' AND auth.role() = 'authenticated');