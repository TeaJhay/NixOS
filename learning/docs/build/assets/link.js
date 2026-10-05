document.addEventListener("DOMContentLoaded", () => {
  const links = [
    {
      label: "GitHub repository",
      href: "https://github.com/teajhay/nixos",
      svg: `<svg viewBox="0 0 16 16" width="24" height="24" fill="currentColor" aria-hidden="true"><path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/></svg>`,
    },
    {
      label: "Matrix chat",
      href: "https://matrix.to/#/@teajhay:mozilla.org",
      // Paste any SVG here (e.g. from simple-icons.org or lucide.dev)
      src: "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/matrix-light.svg",
    },
    {
      label: "Discord chat",
      href: "https://discord.com/users/233122104973721600",
      // Paste any SVG here (e.g. from simple-icons.org or lucide.dev)
      src: "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/discord.svg",
    },
  ];

  const wrap = document.createElement("div");
  wrap.style.cssText = "display:inline-flex;align-items:center;gap:.75rem;margin-left:.75rem";

  for (const { label, href, svg, src} of links) {
    const a = document.createElement("a");
    a.href = href;
    a.target = "_blank";
    a.rel = "noopener";
    a.setAttribute("aria-label", label);
    a.title = label;
    a.style.cssText = "display:inline-flex;color:inherit;opacity:.8;line-height:0";
    a.onmouseenter = () => (a.style.opacity = 1);
    a.onmouseleave = () => (a.style.opacity = 0.8);
    if (src) {
      const img = document.createElement("img");
      img.src = src;
      img.alt = "";
      img.width = 24;
      img.height = 24;
      a.appendChild(img);
    } else {
        a.innerHTML = svg;
    }
    wrap.appendChild(a);
  }

  const search = document.querySelector(
    'input[type="search"], input[id*="search" i], input[class*="search" i]'
  );
  const container = search && (search.closest('[class*="search" i]') || search.parentElement);

  if (container) {
    container.parentElement.style.display = "flex";
    container.parentElement.style.alignItems = "center";
    container.after(wrap);
  } else {
    wrap.style.cssText += ";position:fixed;top:.75rem;right:1rem;z-index:1000";
    document.body.appendChild(wrap);
  }
});
