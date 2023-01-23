```diff
diff --git a/app/static/frontend/containers/QuorumFrame.jsx b/app/static/frontend/containers/QuorumFrame.jsx
index 1383706dfca..0de42ed889f 100644
--- a/app/static/frontend/containers/QuorumFrame.jsx
+++ b/app/static/frontend/containers/QuorumFrame.jsx
@@ -16,9 +16,7 @@ const App = (props) => {
             <Frame location={props.location} />
             <div id="container">
                 <div id="first-row">
-                    <ErrorBoundary>
-                        <div className="main">{props.children}</div>
-                    </ErrorBoundary>
+                    <div className="main">{props.children}</div>
                 </div>
             </div>
         </div>
```