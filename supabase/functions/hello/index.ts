// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.


// const { onRequest } = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");


const final_function = (playersAmount, roundsAmount) => {
  const teamConstraint = true; // If people from same two teams should play

  // const playersAmount = request.query.players;
  // const roundsAmount = request.query.rounds;

  if (playersAmount == null || roundsAmount == null) {
    // response.send("Necesito parámetros players y rounds")
  }

  if (playersAmount % 4 != 0) {
    // response.send('Necesito que el número de players sea divisible por 4')
  }

  function generateRangeArray(amount, step = 1) {
    const rangeArray = [];

    for (let i = 0; i < amount; i += step) {
      rangeArray.push(i);
    }

    return rangeArray;
  }

  function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1)); // Random index within the remaining unshuffled portion
      [array[i], array[j]] = [array[j], array[i]]; // Swap elements
    }
  }

  const tableChecker = (players, _chosenPlayers) => { // Checks that all players belong to different teams
    const teamsNumbers = players.map(n => Math.floor(n / 4));
    const teamsSet = new Set(teamsNumbers);
    if (Array.from(teamsSet).length != 4) {
      return false;
    }
    if (!teamConstraint) {
      return true;
    }

    const pairings = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]
    const pairedPlayers = pairings.map((a, b) => [players[a], players[b]])

    const havePlayedBefore = pairedPlayers.some((a, b) => {
      return tables.some((round) => {
        return round.some((table) => {
          return table.includes(a) && table.includes(b);
        })
      })
    })

    return !havePlayedBefore;
  }



  const generation = (chosenPlayers, players) => {

    if (players.length == 4) {
      return [players]
    }

    shuffleArray(players);

    let candidatePlayers = players.slice(0, 4).sort((function (a, b) {
      return a - b; // Sort in ascending order; for descending order, use b - a
    }));

    while (!tableChecker(candidatePlayers, chosenPlayers)) {
      shuffleArray(players);
      candidatePlayers = players.slice(0, 4);
    }


    const remainingPlayers = players.slice(4);

    return [candidatePlayers].concat(generation(chosenPlayers, remainingPlayers));
  }



  const players = generateRangeArray(playersAmount)

  let i = 0;
  let tables = [];

  for (i = 0; i < roundsAmount; i++) {
    const players2 = players
    const round = generation([], players2)
    tables.push(round);
  }


  let responseText = "";
  let txt = ""
  tables.forEach((round, roundIndex) => {
    txt = `<div><h2>Round ${roundIndex + 1}</h2></div>`
    responseText += txt
    // logger.info(txt);

    round.forEach((table, tableIndex) => {
      txt = `<div><span>Table ${tableIndex + 1}</span> ${table.map((i) => `<span>${i + 1}</span>`)}</div>`
      responseText += txt
      // logger.info(txt);
    })
  });

  responseText = `
  <html>
      <head>
          <title>Pairing Generator v1</title>
      </head>
      <body>
      <h1>Players: ${playersAmount} Rounds: ${roundsAmount}</h1>
          ${responseText}
      </body>
  </html>
`

  const final_value = {
    playersAmount: playersAmount,
    roundsAmount: roundsAmount
  }

  return final_value
}








Deno.serve(async (req) => {
  const { name } = await req.json()
  const data = {
    message: `Hello ${name}!`,
  }


  const data2 = final_function(880, 28)

  return new Response(
    JSON.stringify(data2),
    { headers: { "Content-Type": "application/json" } },
  )
})











/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/hello' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
