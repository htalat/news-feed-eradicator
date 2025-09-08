import typescript from '@rollup/plugin-typescript';
import css from 'rollup-plugin-css-only';
import resolve from 'rollup-plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import replace from '@rollup/plugin-replace';
import { string } from 'rollup-plugin-string'

const plugins = [
	resolve(),
	commonjs(),
	typescript(),
	replace({
		'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
	}),
	string({
		include: "**/*.str.css"
	}),
];

const isSafari = process.env.BUILD === 'safari';
const buildDir = isSafari ? 'build-safari' : 'build';

const intercept = {
	input: 'src/intercept.ts',
	output: {
		file: `${buildDir}/intercept.js`,
		format: 'iife',
	},
	plugins: [...plugins, css({ exclude: '**/*.str.css', output: `${buildDir}/eradicate.css` })],
};

const options = {
	input: 'src/options/options.ts',
	output: {
		file: `${buildDir}/options.js`,
		format: 'iife',
	},
	plugins: [...plugins, css({ exclude: '**/*.str.css', output: `${buildDir}/options.css` })],
};

const background = {
	input: 'src/background/service-worker.ts',
	output: {
		file: `${buildDir}/service-worker.js`,
		format: 'iife',
	},
	plugins,
};

export default [intercept, options, background];
