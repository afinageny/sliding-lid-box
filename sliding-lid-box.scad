

function orthogonal_2d(v) = [-v[1], v[0]];

function translateLength(v, direction, length) =[v[0] + direction[0]*length, 
          v[1] + direction[1]*length, 
          v[2]];


module bevel(start, direction, width, height, length) {
    eps= 2;
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

    pEps0 = [start[0] - ortoDirection[0]*eps, 
          start[1] - ortoDirection[1]*eps, 
          start[2]];

    pEps1 =[start[0] - ortoDirection[0]*eps,
           start[1] - ortoDirection[1]*eps, 
           start[2] - height];

    pEps3 = translateLength(pEps0, direction, length);
    pEps4 = translateLength(pEps1, direction, length);

   points = [
      p0, 
      p1,
      p2,
      p3,
      p4,
      p5,
      pEps0, // 6
      pEps1, // 7
      pEps3, // 8
      pEps4, // 9

   ];

        polyhedron(points = points, 
        faces = [[2,6,7,1], 
                [5,8,9,4],

                [6,8,9,7],

                [5,8,6,2],
                [5,4,1,2],
                [4,9,7,1] 
        ]);
  
}


module roundXBevel(start, bevelRadius, bevelLength){

    difference() {
        bevel(start=start, 
            direction=[1,0], width=bevelRadius, height=bevelRadius, length=bevelLength);

        translate([start[0], start[1]+bevelRadius , start[2]-bevelRadius])
            rotate([0, 90, 0])
                cylinder(h=bevelLength, r=bevelRadius);

    }
}


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

   



module frame (width, length, thikness, frameWidth) {
    difference() {
        cube([width,  length, thikness]);
        translate([frameWidth, frameWidth, 0])
            cube([width-2*frameWidth,  length-2*frameWidth, 2*thikness]);
    }      
};



module cubeRoundZCorners (width, length, thikness, cornerRadius, 
    corners
                        ) {


 
        hull(){
            if(corners[0]==0){
                cube([cornerRadius, cornerRadius, thikness]);
            } else {
                translate([cornerRadius, cornerRadius, 0])
                    cylinder(h=thikness, r=cornerRadius);
            }


            if(corners[1]==0){
                translate([width-cornerRadius, 0, 0])
                    cube([cornerRadius, cornerRadius, thikness]);
            } else {
               translate([width-cornerRadius, cornerRadius, 0])
                    cylinder(h=thikness, r=cornerRadius);         
            }
            
            if(corners[2]==0){   
                translate([width-cornerRadius, length-cornerRadius, 0])
                    cube([cornerRadius, cornerRadius, thikness]);
            } else {
                translate([width-cornerRadius, length-cornerRadius, 0])
                    cylinder(h=thikness, r=cornerRadius);
            }

            if(corners[3]==0){
                translate([0, length-cornerRadius, 0])
                    cube([cornerRadius, cornerRadius, thikness]);
            } else {
                translate([cornerRadius, length-cornerRadius, 0])
                    cylinder(h=thikness, r=cornerRadius);
            }
        }   
}

module cubeRoundZCornersLatch (width, length, thikness, cornerRadius, 
    corners, latches) {
    
    cubeRoundZCorners(width, length, thikness, cornerRadius, corners);            
                        
    sphereRadius= thikness/4; 

    eps = 0.0;


    delta = width/(latches+1);


    for (sphereIndex = [0 : 1 : latches-1]) {

        translate([delta + sphereIndex*delta, eps, thikness/2]){
            sphere(r=sphereRadius);
        }

         translate([delta + sphereIndex*delta, length-eps, thikness/2]){
            sphere(r=sphereRadius);
        }
    }
                        
}






module frameRound2Corners (width, length, thikness, cornerRadius, frameWidth) {
    difference() {
        cube([width, width, thikness]);
        translate([frameWidth, frameWidth, 0])
            cube([width-2*frameWidth,  length-2*frameWidth, 2*thikness]);
    }      
};




module glassFrame(
    width, 
    length,
    cornerRadius, 
    glassFrameWidth,
    glassFrameThikness,
)
{    
    difference() {
   
            cubeRoundZCorners(
                width=width, 
                length= length, 
                glassFrameWidth, 
                cornerRadius=2, corners=[1,1,1,1]);

       


    }
  

}










module boxLid(
    width, 
    length,
    thikness, 
    frameWidth, 
    cornerRadius, 
    doveTailWidth,
    glassFrameWidth,
    glassFrameThikness,
) {

    diffEps=1;

    difference() {

        cube(
            [width, length+doveTailWidth, thikness]);
        
        bevel(start=[width+diffEps, length+doveTailWidth, thikness], direction=[-1, 0], width=doveTailWidth,  height=thikness,    length=length+2*diffEps);   

        roundXBevel([0,0,thikness], thikness/2, width);

        bevel(start=[0, length+diffEps, thikness], direction=[0, -1], width=doveTailWidth, height=thikness,    length=length+diffEps);     

        bevel(start=[width, 0, thikness], direction=[0, 1], width=doveTailWidth, height=thikness,    length=length+diffEps);   


        


    }      
};


module box(width, height, length, cornerRadius, thikness) {
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



module main(){
    width = 42*3;
    length = 42*4;
    height = 6*7;
    thikness = 4;

    frameWidth = 10;


    doveTailWidth = thikness*0.3;

    stileColor = [0, 1, 0, 0.8];

    frontRailColor= [1, 1, 0, 0.8];

    eps = 0.1;
    glassThikness = 0.4;
    glassFrameThikness = thikness/2 - eps;
    glassFrameWidth = thikness;



    cornerRadius = thikness/2;

    $fn = 30;



    boxLidWidth= width-2*(thikness-doveTailWidth);
    boxLidLength = length-thikness;


    module lidGlassFrameCut(height) {
        translate([glassFrameWidth, glassFrameWidth, 0])
                cubeRoundZCorners(
                        width=width-2*frameWidth-2*glassFrameWidth, 
                        length=length-2*frameWidth-2*glassFrameWidth,     
                        thikness=height, 
                        cornerRadius=cornerRadius,
                        corners=[1,1,1,1]);   
    }


    module lidGlassFrame() {
        difference(){
          cubeRoundZCornersLatch(
                    width=width-2*frameWidth, 
                    length=length-2*frameWidth,     
                    thikness=glassFrameThikness, 
                    cornerRadius=cornerRadius,
                    corners=[1,1,1,1],
                    latches=width/10);   
            lidGlassFrameCut(glassFrameThikness);             
                         
        }

                    
    }


    module lid (){
        
        difference() {
            boxLid(
                width = boxLidWidth, 
                length=boxLidLength, 
                thikness, 
                frameWidth,     
                cornerRadius=cornerRadius,
                doveTailWidth=doveTailWidth, glassFrameWidth=glassFrameWidth,    
                glassFrameThikness=glassFrameThikness );




            color([1,1,1])
            translate([frameWidth-(thikness-doveTailWidth),frameWidth, thikness-glassFrameThikness])
            { 
                lidGlassFrame();   
            }
            translate([frameWidth-(thikness-doveTailWidth),frameWidth, 0]) 
            {
               lidGlassFrameCut(thikness);       
            }
                


                   

        }


    
    }

    module printableBox() { 
        difference() {
            box(width=width, height=height, length=length, thikness=thikness, cornerRadius=thikness/2);
        
            translate([thikness-doveTailWidth, 0, height-thikness])     
                    lid();
        }

    }


   printableBox();


    translate([width+10,0, 0])     
       lid();

    translate([width+10, -boxLidLength, -glassThikness]) {
        difference() {  
            lidGlassFrame();

            translate([0,0, -(glassFrameThikness-glassThikness)])
                lidGlassFrame();
            
        }
    }
/*
    translate([thikness-doveTailWidth, 0, height-thikness])     
       lid();
*/

}
    
$fn = 30;
main();





