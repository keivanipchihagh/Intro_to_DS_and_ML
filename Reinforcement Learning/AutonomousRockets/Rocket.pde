// Keivan Ipchi Hagh
// NOC - Chapter 9 - Generic Algorithms

// Each rocket object contains DNA and corresponding methods to manipulate the data structure - Phenotype
class Rocket {

  // Basic mover variables
  PVector location;
  PVector velocity;
  PVector acceleration;

  // Fitness level
  float fitness;

  // Indicates which force we are putting in effect
  int geneCounter;

  boolean hitObstacle = false;    // Am I stuck on an obstacle?
  boolean hitTarget = false;   // Did I reach the target

  // Object radius for display
  float radius;

  // DNA - the Genotype
  DNA dna;

  // #1 Rocket Constructor
  Rocket(PVector location, DNA dna) {

    // Initialize fields
    this.location = location.get();  // Make A Copy!!! NOT Referese    
    this.dna = dna;
    acceleration = new PVector();
    velocity = new PVector();
    geneCounter = 0;
    radius = 4;
  }

  // Run, wraps all the methods we want to call
  void run(ArrayList<Obstacle> obstacles) {

    if (!targetHit() && !hitObstacle) {  // Have we reached the destination yet?

      applyForce(dna.genes[geneCounter]);  // Apply the corresponding force (For each cycle we have the appropriate gene vector)
      geneCounter++; // Index the next force in the DNA-genes array
      update(); // Update rocket's location, velocity, acceleration, ...

      // If I hit an edge or an obstacle
      obstacles(obstacles);
    }

    if (!hitObstacle)
      display();  // Display the Phenotype
  }

  // Did I hit an obstacle?
  void obstacles(ArrayList<Obstacle> obstacles) {
    for (Obstacle obstacle : obstacles) {
      if (obstacle.contains(location)) {
        hitObstacle = true;
      }
    }
  }

  // Did I make it to the target?
  boolean targetHit() {
    return (dist(location.x, location.y, target.location.x, target.location.y) < 12) ? true : false;
  }

  // Update method
  void update() {   
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);  // Reset acceleration (Basic physics formula)
  }

  // Apply force to acceleration (Not obeying th physics rule FORCE = ACCELERATION * MASS) - Mass is default
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  // Fitness function, calculates the fitness score for the rocket based on its distance to the target
  void calculateFitness(Obstacle target) {
    //fitness = pow(1 / dist(location.x, location.y, target.x, target.y), 2);
    float d = dist(location.x, location.y, target.location.x, target.location.y);
    fitness = pow(1/d, 2);
    
    if (hitObstacle)
      fitness *= 0.1;
  }

  // Display method, draw the rocket body along with its thrusters and etc
  void display() {
    float theta = velocity.heading2D() + PI/2;
    fill(200, 100);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);

    // Thrusters
    rectMode(CENTER);
    fill(0);
    rect(-radius / 2, radius * 2, radius / 2, radius);
    rect(radius / 2, radius * 2, radius / 2, radius);

    // Rocket body
    fill(175);
    beginShape(TRIANGLES);
    vertex(0, -radius * 2);
    vertex(-radius, radius * 2);
    vertex(radius, radius * 2);
    endShape();

    popMatrix();
  }

  // Getter: fitness
  float getFitness() {
    return fitness;
  }

  // Getter: DNA
  DNA getDNA() {
    return dna;
  }

  // Getter: hit status
  boolean stopped() {
    return hitObstacle;
  }
}
