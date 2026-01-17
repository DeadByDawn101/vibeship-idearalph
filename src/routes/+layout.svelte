<script lang="ts">
  import '../app.css';
  import { onMount } from 'svelte';
  import { invalidate } from '$app/navigation';
  import { page } from '$app/stores';
  import { Navbar } from '$lib/components';

  let { children, data } = $props();

  // Pages where navbar should be hidden (auth pages have their own design)
  const hideNavbarRoutes = ['/auth/login', '/auth/signup'];
  const showNavbar = $derived(!hideNavbarRoutes.includes($page.url.pathname));

  // Supabase auth state listener
  onMount(() => {
    const { data: { subscription } } = data.supabase.auth.onAuthStateChange(
      (event, session) => {
        if (session?.expires_at !== data.session?.expires_at) {
          invalidate('supabase:auth');
        }
      }
    );

    return () => subscription.unsubscribe();
  });
</script>

<svelte:head>
  <title>IdeaRalph - The Dumbest Genius You'll Ever Meet</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
  <link
    href="https://fonts.googleapis.com/css2?family=Fredoka+One&family=Patrick+Hand&family=Inter:wght@400;500;600;700&display=swap"
    rel="stylesheet"
  />
</svelte:head>

{#if showNavbar}
  <Navbar user={data.user} />
{/if}

<div class="min-h-full">
  {@render children()}
</div>
