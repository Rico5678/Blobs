class Population{
  ArrayList<Blob> individuals;
  
  Population(){
    individuals = new ArrayList<Blob>();
  }
  
  void drive(){
    for (int i = individuals.size()-1; i>=0; i--){
      Blob individual = individuals.get(i);
      individual.drive();
    }
  }
  
  void display(){
    for (int i = individuals.size()-1; i>=0; i--){
      Blob individual = individuals.get(i);
      individual.display();
    }
  }
  
  void check_collisions(){
      // cycle through all blobs
    for (int i = blobs.individuals.size()-1; i>=0; i--){
      Blob blob = blobs.individuals.get(i);
    
      // check if blobs hit walls
      blob.check_wall_collision();
    
      //check if blobs hit each other
      for (int j = i-1; j>=0; j--){
        Blob other_blob = blobs.individuals.get(j);
        blob.check_blob_collision(other_blob);
        
        // remove dead blobs from array
        if (blob.r <= 0){
          blobs.individuals.remove(i);  //<>//
          break;
        }
        // remove dead blobs from array
        if (other_blob.r <= 0){
          blobs.individuals.remove(j); //<>//
          i--;
          continue;
        } 
      }
    
      // check if blobs hit food
      for (int j = foods.size()-1; j>=0; j--){
        Food food = foods.get(j);
        blob.check_food_collision(food);
        
        // remove dead food and add a new food
        if (food.r <= 0){
         foods.remove(j);
         Food new_food = new Food(color(random(255), random(255), random(255), 100), 2.5, random(0, width), random(0, height), food_energy);
         foods.add(new_food);
         continue;
        }
      }
    }
  }
  
  void evaluate_fitness(){
    for (int i = individuals.size()-1; i>=0; i--){
      Blob individual = individuals.get(i);
      individual.fitness = 10*individual.max_r + individual.age/1000;
    }
  }
  
  void reproduce(){
    if (individuals.size() <= pop_no-2){
      
      // roulette wheel selection
      
      // get fitness total from population
      float roulette_total = 0;
      for (int j = individuals.size()-1; j>=0; j--){
        Blob individual = individuals.get(j);
        roulette_total += individual.fitness;
      }
      
      // spin the wheel twice to select two parents
      int h = 0;
      float roulette_spin = random(0, roulette_total);
      while (roulette_spin > 0){
        Blob individual = individuals.get(h);
        roulette_spin -= individual.fitness;
        h++;
      }
      Blob parent_1 = individuals.get(h-1);
      float[] parent_chromosome_1 = parent_1.chromosome;
      
      h = 0;
      roulette_spin = random(0, roulette_total);
      while (roulette_spin > 0){
        Blob individual = individuals.get(h);
        roulette_spin -= individual.fitness;
        h++;
      }
      Blob parent_2 = individuals.get(h-1);
      float[] parent_chromosome_2 = parent_2.chromosome;
      
      // two point crossover
      int cross_point_1 = int(random(0, parent_chromosome_1.length));
      int cross_point_2 = int(random(0, parent_chromosome_2.length));
      int cross_index_1 = min(cross_point_1, cross_point_2);
      int cross_index_2 = max(cross_point_1, cross_point_2);
      float[] crossover_11 = subset(parent_chromosome_1, 0, cross_index_1);
      float[] crossover_12 = subset(parent_chromosome_1, cross_index_1, (cross_index_2-cross_index_1));
      float[] crossover_13 = subset(parent_chromosome_1, cross_index_2, (parent_chromosome_1.length-cross_index_2));
      float[] crossover_21 = subset(parent_chromosome_2, 0, cross_index_1);
      float[] crossover_22 = subset(parent_chromosome_2, cross_index_1, (cross_index_2-cross_index_1));
      float[] crossover_23 = subset(parent_chromosome_2, cross_index_2, (parent_chromosome_2.length-cross_index_2));
      
      float[] baby_chromosome_1 = concat(concat(crossover_11,crossover_22), crossover_13);
      float[] baby_chromosome_2 = concat(concat(crossover_21,crossover_12), crossover_23);
      
      baby_chromosome_1[baby_chromosome_1.length-3] = parent_chromosome_1[baby_chromosome_1.length-3];
      baby_chromosome_1[baby_chromosome_1.length-2] = parent_chromosome_1[baby_chromosome_1.length-2];
      baby_chromosome_1[baby_chromosome_1.length-1] = parent_chromosome_1[baby_chromosome_1.length-1];
      baby_chromosome_1[baby_chromosome_2.length-3] = parent_chromosome_2[baby_chromosome_2.length-3];
      baby_chromosome_1[baby_chromosome_2.length-2] = parent_chromosome_2[baby_chromosome_2.length-2];
      baby_chromosome_1[baby_chromosome_2.length-1] = parent_chromosome_2[baby_chromosome_2.length-1];
      
      // mutation 
      for (int j = 0; j<baby_chromosome_1.length; j++){
        float mutation = random(0, 1);
        if (mutation < mutation_rate){
          baby_chromosome_1[j] = random(-2, 2); 
        }
      }
      for (int j = 0; j<baby_chromosome_2.length; j++){
        float mutation = random(0, 1);
        if (mutation < mutation_rate){
          baby_chromosome_2[j] = random(-2, 2); 
        }
      }
    Blob blob1 = new Blob(r_start, sp_max, vis_mult, d_inputs_n, a_inputs_n, "NN");
    blob1.chromosome = baby_chromosome_1;
    blob1.rebuild();
    individuals.add(blob1);
    
    Blob blob2 = new Blob(r_start, sp_max, vis_mult, d_inputs_n, a_inputs_n, "NN");
    blob2.chromosome = baby_chromosome_2;
    blob2.rebuild();
    individuals.add(blob2);
    }
  }
  
}