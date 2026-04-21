// Shared response helpers for API routes under /api/v{N}/.
//
// Single source of truth for content-type headers and error shape. All
// handlers must use these — do not re-implement `new Response(JSON.stringify(...))`
// inline. See docs/constraints.md "API surface".

export function json<T extends object>(body: T, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

export function jsonError(message: string, status: number): Response {
  return json({ error: message }, status);
}
