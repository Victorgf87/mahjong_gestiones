export default function Index({ leagues}) {
  return (
    <>
      {leagues.map((league) => (
       <li key={league.id}>{league.name}</li>
      ))}
      <h1>Leagues#index</h1>
      <p>Find me in app/frontend/pages/Leagues/Index.jsx</p>
    </>
  );
}
