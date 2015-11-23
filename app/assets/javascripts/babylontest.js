var BabylonTestController = Paloma.controller("BabylonTest");

BabylonTestController.prototype.index = function(){
  console.log('loaded babylon test');

  var baseTarget = new BABYLON.Vector3(56045, 2453534,0);

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
    scene.clearColor = new BABYLON.Color3(0.9,0.9,0.9);

    // create a FreeCamera, and set its position to (x:0, y:5, z:-10)
    //var camera = new BABYLON.FreeCamera('camera1', new BABYLON.Vector3(56045, 2453534, 0), scene);
    //var camera = new BABYLON.FreeCamera('camera1', BABYLON.Vector3.Zero(), scene);
    // Parameters : name, alpha, beta, radius, target, scene
    //var camera = new BABYLON.ArcRotateCamera("camera1", 2.0, 2.0, 100, baseTarget, scene);
    var camera = new BABYLON.ArcRotateCamera("camera1", 1, 1, 0, BABYLON.Vector3.Zero(), scene);
    //camera.setPosition(baseTarget);
    //camera.setPosition(new BABYLON.Vector3(10000, 10000,10000));
    camera.setPosition(new BABYLON.Vector3(100, 100,100));

    // target the camera to scene origin
    //camera.setTarget(baseTarget);
    camera.setTarget(BABYLON.Vector3.Zero());

    // attach the camera to the canvas
    camera.attachControl(canvas, false);

    // create a basic light, aiming 0,1,0 - meaning, to the sky
    var light = new BABYLON.HemisphericLight('light1', new BABYLON.Vector3(0, 1,0), scene);

    var sphere = BABYLON.Mesh.CreateSphere("sphere", 10, 4000, scene, false);
    //sphere.setPositionWithLocalVector(new BABYLON.Vector3(1000, 1000, 0) );
    sphere.setPositionWithLocalVector(baseTarget);

    var shape_path = '/studio_connections/4/repositories/W_SARAWAKREGIONAL_MYS/object_shape/C83104BA93FD480FABF0916944421CCB.json';
    // Creation of a lines mesh
    console.log('attempt to load shapes');
    var polyline;
    var linePath = [];
    $.get(shape_path, null, function(data, textStatus, jqXHR){
        $.each( data.shape, function(polyline_i, polyline_v){
          linePath = [];
          $.each(polyline_v, function(point_i, point_v){
              linePath.push( [ point_v[0], point_v[1], point_v[2] ]);
          });
          polyline = BABYLON.Mesh.CreateLines("lines", linePath, scene);
        });

        console.log("lines loaded");
    }, 'json');

    console.log(polyline);

    showAxis(50000, scene);

    // return the created scene
    return scene;
  }

  window.addEventListener('DOMContentLoaded', function(){
      var canvas = document.getElementById("renderCanvas");
      var engine = new BABYLON.Engine(canvas, true);
      var scene = createScene(canvas, engine);

      engine.runRenderLoop(function(){
          scene.render();
      });

      window.addEventListener('resize', function(){
          engine.resize();
      })
  });

};
