export const LANES = ['writing', 'work', 'building', 'archive', 'about', 'work-with-me'] as const;
export type Lane = typeof LANES[number] | 'home';

export function deriveLane(pathname: string): Lane {
  for (const lane of LANES) {
    if (pathname.includes(`/${lane}/`) || pathname.endsWith(`/${lane}`)) {
      return lane;
    }
  }
  return 'home';
}
