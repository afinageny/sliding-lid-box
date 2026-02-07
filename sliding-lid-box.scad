width = 50;
length = 50;
height = 30;
thikness = 3;

frameWidth = 10;

railLength = width-2*frameWidth-thikness;
stileLength = length-thikness;


stileColor = [0, 1, 0, 0.8];

frontRailColor= [1, 1, 0, 0.8];

tongueWidth = 0.8*thikness;
eps = 0.1;

$fn = 30;
cornerRadius = thikness/2;


function orthogonal_2d(v) = [-v[1], v[0]];

function translateLength(v, direction, length) =[v[0] + direction[0]*length, 
          v[1] + direction[1]*length, 
          v[2]];




module tongue(start, direction, width, height, length) {
    
    ortoDirection = orthogonal_2d(direction);
    
    p0 = start;
    p1 = [start[0], 
          start[1], 
          start[2] - height];
    p2 = [start[0] + ortoDirection[0]*width, 
          start[1] + ortoDirection[1]*width, 
          start[2]-height];

    p3 = [start[0] + ortoDirection[0]*width, 
          start[1] + ortoDirection[1]*width, 
          start[2]];

    p4 = translateLength(p0, direction, length);

    p5 = translateLength(p1, direction, length);

    p6 = translateLength(p2, direction, length);

    p7 = translateLength(p3, direction, length);


   points = [
      p0, 
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7
   ];

   polyhedron(points = points, 
   faces = [
      [0,1,2,3], 
      [4,5,6,7], 
      [1,0,4,5],
      [0,4,7,3],
      [2,3,7,6],
      [1,2,6,5],
   ]);


}



module bevel(start, direction, width, height, length) {
    ortoDirection = orthogonal_2d(direction);
    
    p0 = start;
    p1 = [start[0], 
          start[1], 
          start[2] - height];

    p2 = [start[0] + ortoDirection[0]*width, 
          start[1] + ortoDirection[1]*width, 
          start[2]];

    p3 = translateLength(p0, direction, length);
    p4 = translateLength(p1, direction, length);
    p5 = translateLength(p2, direction, length);

   points = [
      p0, 
      p1,
      p2,
      p3,
      p4,
      p5

   ];

   polyhedron(points = points, 
   faces = [[0,1,2], 
            [3, 4,5],
            [0, 3, 4,1],
            [0, 3, 5, 2],
            [1, 2 ,5, 4]
   ]);

}





module stile() {
      color(stileColor)  
      difference() {
            difference() {
                        cube([frameWidth,stileLength,thikness]);
                        tongue(
                              start=[frameWidth,0,thikness*2/3], 
                              direction=[0,1], 
                              width=tongueWidth, 
                              height=thikness/3, 
                              length=stileLength
                              );};

            bevel(
                  start=[0,stileLength, thikness], 
                  direction=[0,-1], 
                  width=0.2*thikness, 
                  height=thikness, 
                  length=100);
      }


      

}

module rail(){

      difference() {
            union()  {
                  cube([railLength,frameWidth,thikness]);
                  tongue(
                        start=[railLength+tongueWidth-eps,0,thikness*2/3], 
                        direction=[0,1], 
                        width=tongueWidth-eps, 
                        height=thikness/3, 
                        length=frameWidth
                        );
                  tongue(
                        start=[0,0,thikness*2/3], 
                        direction=[0,1], 
                        width=tongueWidth-eps, 
                        height=thikness/3, 
                        length=frameWidth
                        );
                        
            };
      tongue(
            start=[-tongueWidth, frameWidth-tongueWidth,thikness*2/3], 
            direction=[1,0], 
            width=tongueWidth, 
            height=thikness/3, 
            length=railLength+2*tongueWidth
            );


      }
}

module roundXBevel(start, bevelRadius, bevelLength){


    difference() {
        bevel(start=start, 
            direction=[1,0], width=bevelRadius, height=bevelRadius, length=bevelLength);

        translate([start[0], start[1]+bevelRadius , start[2]-bevelRadius])
            rotate([0, 90, 0])
                cylinder(h=bevelLength, r=thikness/2);

    }
}



module leftStile(){
    difference() {
        stile();
        roundXBevel([0,0,thikness], thikness/2, width);
    }
}

module rightStile(){
    difference() {
        translate([frameWidth,stileLength,0])
        rotate([0, 00, 180])
            stile();
        roundXBevel([0,0,thikness], thikness/2, width);
    }
}

module backRail(){

    rail();
}


module frontRail(){

    difference() {
        rail();
        roundXBevel([0,0,thikness], thikness/2, width);
    }
}

module frame (){
    leftStile();

    translate([railLength+frameWidth,0,0])
        rightStile();

    color(frontRailColor)
    translate([frameWidth,0,0])
        frontRail();   

    translate([frameWidth,stileLength-frameWidth,0])
        backRail();
}


// translate([thikness/2,0,height-thikness])
//     frame();


module box() {
    difference() {
        minkowski() {
            translate([cornerRadius, cornerRadius, cornerRadius]) 
            cube([width-2*cornerRadius, length-2*cornerRadius, height-2*cornerRadius]);
            sphere(r=cornerRadius);
        };
        translate([thikness, thikness, thikness])
            cube([width-2*thikness, length-2*thikness, height-thikness]);
    }
}

color([0, 1, 1, 0.4])
difference() {
    box();
    translate([thikness/2,0,height-thikness])
        frame();
}

translate([-2*thikness, 0,frameWidth]) 
    rotate([0, 90,0])
        leftStile();

translate([width+2*thikness, 0, 0 ]) 
    rotate([0, -90,0])
        rightStile();


translate([frameWidth, -thikness, 0]) 
    rotate([90, 0,0])
        frontRail();



 translate([frameWidth, 2*thikness+length, 0]) 
    rotate([90, 0,0])
        backRail();


