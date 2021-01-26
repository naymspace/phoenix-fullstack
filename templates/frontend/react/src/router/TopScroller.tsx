import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';

export default function TopScroller() {
  const { pathname } = useLocation();

  useEffect(() => {
    window.focus();
    window.scrollTo(0, 0);
  }, [pathname]);

  return null;
}
