// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
// @ts-ignore
import axios from 'axios';


const api_key = 'fff'



async function obtenerJugadoresMahjong() {
  const url = "http://mahjong-europe.org/ranking/mcr.html";

  async function consultarPerplexity(prompt) {
    const requestData = {
      model: "sonar-pro",
      messages: [
        {
          role: "system",
          content: "Eres un experto en extracción de datos web y análisis de HTML. Extrae la información solicitada y devuélvela en formato JSON."
        },
        {
          role: "user",
          content: prompt
        }
      ],
      stream: false
    };

    try {
      // @ts-ignore

      const response = await axios.post('https://api.perplexity.ai/chat/completions', requestData, {
        headers: {
          // @ts-ignore
          'Authorization': `Bearer ${api_key || process.env.PERPLEXITY_API_KEY}`,
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      });

      return response.data.choices[0].message.content;
    } catch (error) {
      console.error('Error en la consulta a Perplexity:', error);
      throw error;
    }
  }

  const promptExtraccion = `
    1. Accede a la URL: ${url}
    2. Extrae la tabla de ranking de jugadores de Mahjong
    3. Convierte los datos en un array JSON estructurado
    4. Incluye todas las columnas disponibles: posición, nombre, país, puntos, etc.
    5. Devuelve solo el array JSON, sin explicaciones adicionales
  `;

  try {
    const resultadoExtraccion = await consultarPerplexity(promptExtraccion);
    const jugadores = JSON.parse(resultadoExtraccion);
    return jugadores;
  } catch (error) {
    console.error("Error en la extracción de datos:", error);
    throw error;
  }
}

// Uso de la función
// @ts-ignore
Deno.serve(async (req) => {

  let result = {}
  console.log("poposllas")

  try {
    const data = await obtenerJugadoresMahjong();
    result = data;
    console.log("Miden", data.length)
  } catch (error){
    console.log("Error ha sido ", error)
    result = error
  }

  // const data = await obtenerJugadoresMahjong()
  //     .then(jugadores => {
  //       console.log("Lista de jugadores:", jugadores);
  //       result = jugadores;
  //     })
  //     .catch(error => {
  //       console.error("Error al obtener los jugadores:", error);
  //       result = error
  //     });

  console.error("hola");
  console.warn("Warn")

  return new Response(
    JSON.stringify(result),
    { headers: { "Content-Type": "application/json" } },
  )
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/scrapper' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
