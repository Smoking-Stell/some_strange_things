(defn generalOperation [operand]
  (fn [& args]
    (fn [& params]
      (apply operand (mapv (fn [x] (apply x params)) args)))))

(def constant constantly)

(defn variable [name]
  (fn [vars] (vars name)))
(def add (generalOperation +))
(def subtract (generalOperation -))
(def negate subtract)
(def multiply (generalOperation *))

(defn div'
  ([x] (div' 1 x))
  ([x & args] (/ (double x) (apply * args))))
(def divide (generalOperation div'))

(defn mean-calc [& args]
  (/ (apply + args) (count args)))

(def mean (generalOperation mean-calc))

(defn varn-calc [& args]
  (let [sqr (fn [x] (* x x))]
    (- (apply mean-calc (mapv sqr args))
       (sqr (apply mean-calc args)))))

(def varn (generalOperation varn-calc))

(def OPERATIONS
  {'+  add,
   '-  subtract,
   '*  multiply,
   '/  divide
   'mean mean
   'varn varn
   'negate negate}
  )

(def VARIABLES
  {'x (variable "x")
   'y (variable "y")
   'z (variable "z")
   })

(defn parseLevel [x]
  (cond
    (number? x) (constant x)
    (contains? VARIABLES x) (VARIABLES x)
    :else (apply (OPERATIONS (first x)) (mapv parseLevel (rest x)))
    )
  )

(defn parseFunction [expression]
  (parseLevel (read-string expression)))


;objects

(load-file "proto.clj")

(def evaluate (method :evaluate))
(def toString (method :toString))
(def diff (method :diff))

(defn root-element [value-for-evaluate value-for-toString value-for-diff]
  {:evaluate value-for-evaluate
   :toString value-for-toString
   :diff value-for-diff
   })

;(NUMVARIABLES)

; :NOTE: не определять внешним образом
(def _value (field :value))
(def _args (field :args))

(def cons-variable (fn [this value] (assoc this :value value)))

(declare ZERO)

(def Constant
  (constructor
    cons-variable
    (root-element (fn [this _] (_value this))
                  (fn [this] (str (_value this)))
                  (fn [_ _] ZERO))))

(def ZERO (Constant 0))
(def ONE (Constant 1))
(def TWO (Constant 2))


(def Variable
  (constructor
    cons-variable
    (root-element (fn [this vars] (vars (_value this)))
                  (fn [this] (_value this))
                  (fn [this var-diff] (if (= (_value this) var-diff) ONE ZERO)))))

(def operation-proto
  (root-element (fn [this vars]
                   (apply ((field :operation) this)
                          (mapv (fn [x] (evaluate x vars)) (_args this))))
                  (fn [this]
                    (str "(" ((field :sign) this) " "
                         (clojure.string/join " " (mapv toString (_args this))) ")"))
                  (fn [this var-diff]
                    (((field :diff-rule) this) (_args this)
                    (mapv (fn [x] (diff x var-diff)) (_args this))))))

(defn general-operation [operation sign diff-rule]
  (constructor
    (fn [this & args] (assoc this :args args))
    {:operation operation
      :sign sign
      :diff-rule diff-rule
      :prototype operation-proto}))

(def Add (general-operation
           +
           "+"
           (fn [_ diff-args] (apply Add diff-args))))

(def Subtract (general-operation
                -
                "-"
                (fn [_ diff-args] (apply Subtract diff-args))))

(def Negate (general-operation
              -
              "negate"
              (fn [_ diff-args] (apply Subtract diff-args))))

(declare Multiply)
(declare Divide)
(declare GeomMean)
(declare HarmMean)

(declare mul-calc-diff)

(defn mul-calc-diff [args diff-args]
  (second (reduce (fn [[x y] [dx dy]]
                    (vector (Multiply x dx) (Add (Multiply x dy) (Multiply y dx))))
                  (mapv vector args diff-args))))

(def Multiply (general-operation
           *
           "*"
           mul-calc-diff))

(defn div-calc-diff-reserve [args diff-args]
                     (let [x (first args)
                           x-args (rest args)
                           dx-args (rest diff-args)
                           dx (first diff-args)
                           mult (apply Multiply (rest args))]
                       (if (nil? (second args))
                         (Negate (Divide dx (Multiply x x)))
                         (Divide ((Subtract
                                    (Multiply dx mult)
                                    (Multiply x (mul-calc-diff x-args dx-args)))
                                  (Multiply mult mult))))))

(defn div-calc-diff [[x & x-args] [dx & dx-args]]
  (let [mul1 (apply Multiply x-args)]
  (if (nil? (first x-args))
    (Negate (Divide dx (Multiply x x)))
      (Divide (Subtract
                (Multiply mul1 dx)
                (Multiply x (mul-calc-diff x-args dx-args)))
              (Multiply mul1 mul1)))))

(def Divide (general-operation
           div'
           "/"
           div-calc-diff))

(defn arithmean-calc-diff [args diff-args]
  (Divide (apply Add diff-args) (count args)))

(def ArithMean (general-operation
                 mean-calc
                 "arith-mean"
                 (fn [_ diff-args] (apply ArithMean diff-args))))

(defn geomean-calc [& args]
  (Math/pow (Math/abs (apply * args)) (/ 1.0 (count args))))

(def Pow (general-operation
           (fn [& args] (Math/pow (first args) (second args)))
           "pow"
           (fn [_ _] (println "Error"))))

(def Mark (general-operation
            (fn [& args] (let [mult (apply * args)]
                          (/ mult (Math/abs mult))))
            "mark"
            (fn [_ _] (println "Error"))))

(defn geom-calc-diff [args diff-args]
  (let [n (count args)]
    (Multiply (apply Mark args) (Divide (mul-calc-diff args diff-args)
            (Multiply (Pow (apply GeomMean args) (Constant (- n 1))) (Constant n))))
    ))

(def GeomMean (general-operation
           geomean-calc
           "geom-mean"
           geom-calc-diff))

(defn harmean-calc [& args]
  (div' (count args) (apply + (mapv (fn [x] (/ 1.0 x)) args))))

(defn harm-calc-diff [args diff-args]
  (Divide (Multiply (apply Add (map (fn [[x dx]] (Divide dx (Pow x TWO)))
                         (map vector args diff-args)))
            (Pow (apply HarmMean args) TWO))
          (Constant (count args)))
    )

(def HarmMean (general-operation
           harmean-calc
           "harm-mean"
           harm-calc-diff))

(def VARIABLESOBJ
  {'x (Variable "x")
   'y (Variable "y")
   'z (Variable "z")
   })

(def OPERATIONSOBJ
  {'+  Add
   '-  Subtract
   '*  Multiply
   '/  Divide
   'arith-mean ArithMean
   'geom-mean GeomMean
   'harm-mean HarmMean
   'negate Negate
   }
  )

(defn parse-level [x]
  (cond
    (number? x) (Constant x)
    (contains? VARIABLESOBJ x) (VARIABLESOBJ x)
    (list? x) (apply (OPERATIONSOBJ (first x)) (mapv parse-level (rest x)))
    :else (str x)))

(defn parseObject [expression]
  (parse-level (read-string expression)))

;parser
