/** @type {import('tailwindcss').Config} */
export default {
    darkMode: ["class"],
    content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
  	extend: {
  		colors: {
  			'terminal-green': 'rgba(74, 246, 38, 1)',
  			'terminal-green-75': 'rgba(74, 246, 38, 0.75)',
  			'terminal-green-50': 'rgba(74, 246, 38, 0.5)',
  			'terminal-green-25': 'rgba(74, 246, 38, 0.25)',
  			'terminal-yellow': 'rgba(255, 176, 0, 1)',
  			'terminal-yellow-75': 'rgba(255, 176, 0, 0.75)',
  			'terminal-yellow-50': 'rgba(255, 176, 0, 0.5)',
  			'terminal-yellow-25': 'rgba(255, 176, 0, 0.25)',
  			'terminal-black': 'rgba(21, 21, 21, 1)',
			'terminal-gold': 'rgba(211, 175, 55, 1)',
			'terminal-silver': 'rgba(170, 169, 173, 1)',
			'terminal-bronze': 'rgba(169, 113, 66, 1)',
  		},
  		borderRadius: {
  			lg: 'var(--radius)',
  			md: 'calc(var(--radius) - 2px)',
  			sm: 'calc(var(--radius) - 4px)'
  		},
		textShadow: {
			'none': 'none',
		},
  	}
  },
  plugins: [require("tailwindcss-animate")],
}