var BabylonTestController = Paloma.controller("BabylonTest");

BabylonTestController.prototype.index = function(){
}

BabylonTestController.prototype.test = function(){
  console.log('loaded babylon test');

  var baseTarget = new BABYLON.Vector3(56045.4504475519, 2453534.28856592, 0);

  //show axis
  var showAxis = function(size, scene) {
    var makeTextPlane = function(text, color, size) {
      var dynamicTexture = new BABYLON.DynamicTexture("DynamicTexture", 50, scene, true);
      dynamicTexture.hasAlpha = true;
      dynamicTexture.drawText(text, 5, 40, "bold 36px Arial", color , "transparent", true);
      var plane = new BABYLON.Mesh.CreatePlane("TextPlane", size, scene, true);
      plane.material = new BABYLON.StandardMaterial("TextPlaneMaterial", scene);
      plane.material.backFaceCulling = false;
      plane.material.specularColor = new BABYLON.Color3(0, 0, 0);
      plane.material.diffuseTexture = dynamicTexture;
      return plane;
    };

    var axisX = BABYLON.Mesh.CreateLines("axisX", [
      new BABYLON.Vector3.Zero(),
      new BABYLON.Vector3(size, 0, 0), new BABYLON.Vector3(size * 0.95, 0.05 * size, 0),
      new BABYLON.Vector3(size, 0, 0), new BABYLON.Vector3(size * 0.95, -0.05 * size, 0)
      ], scene);
    axisX.color = new BABYLON.Color3(1, 0, 0);
    var xChar = makeTextPlane("X", "red", size / 10);
    xChar.position = new BABYLON.Vector3(0.9 * size, -0.05 * size, 0);
    var axisY = BABYLON.Mesh.CreateLines("axisY", [
        new BABYLON.Vector3.Zero(),
        new BABYLON.Vector3(0, size, 0), new BABYLON.Vector3( -0.05 * size, size * 0.95, 0),
        new BABYLON.Vector3(0, size, 0), new BABYLON.Vector3( 0.05 * size, size * 0.95, 0)
        ], scene);
    axisY.color = new BABYLON.Color3(0, 1, 0);
    var yChar = makeTextPlane("Y", "green", size / 10);
    yChar.position = new BABYLON.Vector3(0, 0.9 * size, -0.05 * size);
    var axisZ = BABYLON.Mesh.CreateLines("axisZ", [
        new BABYLON.Vector3.Zero(),
        new BABYLON.Vector3(0, 0, size), new BABYLON.Vector3( 0 , -0.05 * size, size * 0.95),
        new BABYLON.Vector3(0, 0, size), new BABYLON.Vector3( 0, 0.05 * size, size * 0.95)
        ], scene);
    axisZ.color = new BABYLON.Color3(0, 0, 1);
    var zChar = makeTextPlane("Z", "blue", size / 10);
    zChar.position = new BABYLON.Vector3(0, 0.05 * size, 0.9 * size);
  };

  //create scene
  var createScene = function(canvas, engine){
    // create a basic BJS Scene object
    var scene = new BABYLON.Scene(engine);
    scene.clearColor = new BABYLON.Color3(0.1,0.1,0.1);

    // create a FreeCamera, and set its position to (x:0, y:5, z:-10)
    //var camera = new BABYLON.FreeCamera('camera1', new BABYLON.Vector3(56045, 2453534, 0), scene);
    //var camera = new BABYLON.FreeCamera('camera1', BABYLON.Vector3.Zero(), scene);
    // Parameters : name, alpha, beta, radius, target, scene
    var camera = new BABYLON.ArcRotateCamera("camera1",1.5708, 1.5708, 12000, baseTarget, scene);
  	//var camera = new BABYLON.FreeCamera("camera1", baseTarget, scene);

    // target the camera to scene origin
    //camera.setTarget(baseTarget);
    //camera.setTarget(BABYLON.Vector3.Zero());

    // attach the camera to the canvas
    camera.attachControl(canvas, false);

    // create a basic light, aiming 0,1,0 - meaning, to the sky
    var light = new BABYLON.HemisphericLight('light1', new BABYLON.Vector3(0, 1,0), scene);
    //var light = new BABYLON.DirectionalLight("dir0", new BABYLON.Vector3(0,-1,0), scene);


    //var sphere = BABYLON.Mesh.CreateSphere("sphere", 10, 1000, scene, false);
    //sphere.setPositionWithLocalVector(new BABYLON.Vector3(1000, 1000, 0) );
    //sphere.setPositionWithLocalVector(baseTarget);

    var shape_path = '/studio_connections/4/repositories/W_SARAWAKREGIONAL_MYS/object_shape/C83104BA93FD480FABF0916944421CCB.json';
    // Creation of a lines mesh
    console.log('attempt to load shapes');
    var polylines = [];
    var linePath = [];

    $.get(shape_path, null, function(data, textStatus, jqXHR){
        $.each( data.shape, function(polyline_i, polyline_v){
          linePath = [];
          console.log("loading line " + (polyline_i + 1) + " of " + data.shape.length);

          $.each(polyline_v, function(point_i, point_v){
              linePath.push( new BABYLON.Vector3( point_v[0], point_v[1], point_v[2]) );
          });
          var polyline = BABYLON.Mesh.CreateLines("line" + polyline_i, linePath, scene) ;
          console.log(polyline);
          polylines.push(polyline);
        });

        //merge and reset the camera position
        //var newMesh = BABYLON.Mesh.MergeMeshes(polylines, true, true);
        //camera.target = newMesh;
        //camera.radius = 10000;
        //scene.activeCamera = camera;

        console.log("lines loaded");
    }, 'json');

    /*
    var line = BABYLON.Mesh.CreateLines("lines", [
      new BABYLON.Vector3(56045.4504475519, 2453534.28856592, 0),
  		new BABYLON.Vector3(56010.0062679002, 2453009.14613211, 0),
  		new BABYLON.Vector3(55918.9177645486, 2452356.93941303, 0) ,
  		new BABYLON.Vector3(55914.9921522684, 2451856.32368301, 0),
  		new BABYLON.Vector3(56028.9771660512, 2451476.81006661, 0),
  		new BABYLON.Vector3(56452.8582589728, 2451118.5067016, 0),
  		new BABYLON.Vector3(56728.54202325, 2450988.50542404, 0),
  		new BABYLON.Vector3(57467.7651731223, 2450422.74903634, 0),
  		new BABYLON.Vector3(57654.6022190626, 2449715.86079938, 0),
  		new BABYLON.Vector3(57289.0725515553, 2448869.37021313, 0),
  		new BABYLON.Vector3(57128.3615207948, 2448294.50537145, 0),
  		new BABYLON.Vector3(57122.4712599975, 2447718.57812405, 0),
  		new BABYLON.Vector3(57001.3740661056, 2447092.52032805, 0),
  		new BABYLON.Vector3(56745.4887814538, 2446471.60945109, 0),
  		new BABYLON.Vector3(56263.8372522395, 2445149.86985277, 0),
  		new BABYLON.Vector3(56231.6027628427, 2444370.45137163, 0),
  		new BABYLON.Vector3(56488.2673577172, 2443564.03802853, 0),
  		new BABYLON.Vector3(56531.0874316755, 2443261.90948202, 0),
  		new BABYLON.Vector3(56815.1331998957, 2442327.07871939, 0),
  		new BABYLON.Vector3(56842.4686158478, 2442176.59179954, 0),
  		new BABYLON.Vector3(56835.4489538488, 2441927.03806656, 0),
  		new BABYLON.Vector3(56701.4907188501, 2441602.25913506, 0),
  		new BABYLON.Vector3(56519.3006150461, 2441354.31210991, 0)
  	], scene);
    */

      //showAxis(50000, scene);

      // return the created scene
      return scene;
  }

  window.addEventListener('DOMContentLoaded', function(){
      var canvas = document.getElementById("renderCanvas");
      var engine = new BABYLON.Engine(canvas, true);
      var scene = createScene(canvas, engine);
      scene.debugLayer.show();

      engine.runRenderLoop(function(){
          scene.render();
      });

      window.addEventListener('resize', function(){
          engine.resize();
      })
  });

};
