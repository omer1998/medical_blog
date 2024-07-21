// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import { createClient } from 'npm:@supabase/supabase-js@2'
import { JWT } from 'npm:google-auth-library@9'
import serviceAccount from '../service-account.json' with { type: 'json' }

import "https://esm.sh/@supabase/functions-js/src/edge-runtime.d.ts"

console.log("Hello from Functions!")

interface Notification {
  id: string
  user_id: string
  body: string

}

interface WebhookPayload {
  type: 'INSERT'
  table: string
  record: Notification
  schema: 'public'
}


const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,

  // "https://unhkwlvbdldgqnxmfpaw.supabase.co",
  // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVuaGt3bHZiZGxkZ3FueG1mcGF3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcxMzEwMDg3MSwiZXhwIjoyMDI4Njc2ODcxfQ._OJJjK4odvqCU6yWCj7pXd3rCQOCp8YElDr1plsegks"
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)
console.log("supa url ", Deno.env.get("SUPABASE_URL"));
console.log("supa service role key ",   Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
);

console.log("supabase", supabase);

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json()
  console.log("ssssssupabase payload");
  console.log("payload", payload);

  const { data } = await supabase
    .from('profiles')
    .select('fcm_token, name')
    .eq('id', payload.record.case_author)
    .single()

    

    console.log("data from supabase related to this user");
    console.log(data);

  const fcmToken = data!.fcm_token as string
    console.log("fcmToken", fcmToken);

  const accessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key,
  })
console.log("access token is  ---> ");
console.log(accessToken);
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: fcmToken,
          notification: {
            title: `Case Has been added by ${data!.name}`,
            body: payload.record.case_name,
          },
        },
      }),
    }
  )


  const resData = await res.json()
  if (res.status < 200 || 299 < res.status) {
    throw resData
  }

  return new Response(JSON.stringify(resData), {
    headers: { 'Content-Type': 'application/json' },
  })
})

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string
  privateKey: string
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],

    })
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err)
        return
      }
      resolve(tokens!.access_token!)
    })
  })
}

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/push' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
