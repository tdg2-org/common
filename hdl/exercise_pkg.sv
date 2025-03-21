package exercise_pkg;
  // A packed struct for synthesizable ports
  typedef struct packed {
      logic grn;
      logic yel;
      logic red;
  } tlight_type;

  typedef struct packed {
      logic e;
      logic w;
      logic n;
      logic s;
  } sens_type;
  
  // You can include additional typedefs, constants, functions, etc.
endpackage