if [ -d assets ]; then
	mv assets/images .
	rm -rf assets
fi
mkdir src fonts
mv index.html src
touch src/{input.css,output.css} .prettierrc
echo -n '@import "tailwindcss";' >  src/output.css
echo -n '{
	"plugins": [
	  "prettier-plugin-tailwindcss",
		"prettier-plugin-organize-attributes"
	]
}
' > .prettierrc
echo -n '

node_modules/
.parcel-cache/
' >> .gitignore
pnpm init
pnpm i --prefer-offline tailwindcss @tailwindcss/cli
pnpm i -D --prefer-offline parcel prettier-plugin-tailwindcss prettier-plugin-organize-attributes
jq 'del(.scripts.test)' package.json > tmp.json && mv tmp.json package.json
jq '.scripts += {"start": "npx parcel src/index.html"}' package.json > tmp.json && mv tmp.json package.json
jq '.scripts += {"tailwind-start": "npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --watch"}' package.json > tmp.json && mv tmp.json package.json
jq '.scripts += {"build": "npx parcel build src/index.html"}' package.json > tmp.json && mv tmp.json package.json
jq '.scripts += {"tailwind-start": "npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --build"}' package.json > tmp.json && mv tmp.json package.json
