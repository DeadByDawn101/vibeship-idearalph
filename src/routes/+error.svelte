<script lang="ts">
  import { page } from '$app/stores';
  import { RalphAvatar } from '$lib/components';

  const errorMessages: Record<number, { title: string; quote: string }> = {
    404: {
      title: "Page Not Found",
      quote: "I looked everywhere but I couldn't find it. Maybe it's invisible like my friend!"
    },
    403: {
      title: "Access Denied",
      quote: "The door is locked and I forgot the password. It was 'password' but that didn't work!"
    },
    500: {
      title: "Something Went Wrong",
      quote: "My brain did a thing and now everything is broken. Sorry!"
    }
  };

  const errorInfo = $derived(
    errorMessages[$page.status] || {
      title: "Oops!",
      quote: "Something weird happened. Even I don't know what!"
    }
  );
</script>

<main class="min-h-[calc(100vh-64px)] bg-playground-sunset flex items-center justify-center px-4">
  <div class="text-center max-w-md">
    <!-- Ralph looking confused -->
    <div class="mb-6">
      <RalphAvatar size="xl" mood="confused" animated />
    </div>

    <!-- Error code -->
    <p class="font-chalk text-6xl text-playground-red mb-2">
      {$page.status}
    </p>

    <!-- Error title -->
    <h1 class="font-chalk text-3xl text-chalkboard mb-4">
      {errorInfo.title}
    </h1>

    <!-- Ralph quote -->
    <div class="bg-paper rounded-lg border-4 border-chalkboard p-4 mb-6">
      <p class="ralph-voice text-chalkboard">
        "{errorInfo.quote}"
      </p>
    </div>

    <!-- Error details -->
    {#if $page.error?.message}
      <p class="text-sm text-chalkboard/60 mb-6">
        {$page.error.message}
      </p>
    {/if}

    <!-- Actions -->
    <div class="flex flex-col sm:flex-row gap-3 justify-center">
      <a href="/" class="btn-crayon">
        🏠 Go Home
      </a>
      <button onclick={() => history.back()} class="btn-crayon bg-gray-100">
        ← Go Back
      </button>
    </div>
  </div>
</main>
