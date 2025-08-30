<!DOCTYPE html>

<h1>Thorium</h1>

<p><strong>Thorium</strong> is a <strong>statically-typed functional programming language</strong> that compiles to <strong>Lisp-inspired human-readable bytecode</strong> and runs on a custom VM called <code>element90</code>.</p>

<p>It is designed to be simple, inspectable, and educational, while still supporting advanced features like:</p>
<ul>
    <li>Immutable and mutable variables (<code>@mut</code>)</li>
    <li>Lists and arrays</li>
    <li>Structs and first-class functions</li>
    <li>External functions and built-in standard library functions</li>
    <li>Debug metadata for runtime inspection</li>
</ul>

<h2>Distribution</h2>

<p>Thorium ships as a ZIP file containing:</p>

<pre>
element90           # Thorium VM executable
thbc                # Thorium Bytecode Compiler executable
core/               # Standard library modules
src/                # Source code for element90 and thbc
</pre>

<ul>
    <li><strong>element90</strong>: runs compiled <code>.thprg</code> programs.</li>
    <li><strong>thbc</strong>: compiles <code>.th</code> source code to <code>.thb</code> (human-readable bytecode) or <code>.thprg</code> (compiled program).</li>
    <li><strong>core/</strong>: standard library modules for Thorium programs.</li>
</ul>

<h2>File Types</h2>

<table>
<thead>
<tr><th>Extension</th><th>Description</th></tr>
</thead>
<tbody>
<tr><td><code>.th</code></td><td>Thorium source code (human-editable)</td></tr>
<tr><td><code>.thb</code></td><td>Human-readable bytecode (intermediate representation)</td></tr>
<tr><td><code>.thprg</code></td><td>Compiled program suitable for <code>element90</code></td></tr>
</tbody>
</table>

<h2>Quick Start</h2>

<ol>
<li>Write a Thorium program (<code>demo.th</code>):

<pre><code>@module demo
@use core.io

int numbers = [1 : 2 : 3 : 4 : 5]

function sum_list : nums int[] : int =
    int total
    total = 0
    for n in nums do
        total = total + n
    ret total

io.print : sum_list : numbers
</code></pre>
</li>

<li>Compile the program:

<pre><code>./thbc demo.th</code></pre>

<p>This generates <code>demo.thb</code> (inspectable bytecode) and <code>demo.thprg</code> (compiled program).</p>
</li>

<li>Run the compiled program:

<pre><code>./element90 demo.thprg</code></pre>
</li>
</ol>

<h2>Features</h2>

<ul>
    <li>Statically typed functional language</li>
    <li>First-class functions</li>
    <li>Structs</li>
    <li>Lists and <code>for</code> loops</li>
    <li>External functions for integration with other code</li>
    <li>Built-in debugging support</li>
</ul>

<h2>Use Cases</h2>

<p>Thorium is ideal for:</p>
<ul>
    <li>Learning how a programming language VM works</li>
    <li>Exploring functional programming concepts</li>
    <li>Building small educational projects with a minimal runtime</li>
    <li>Embedding the VM and program into freestanding executables for distribution</li>
</ul>

</body>
</html>
