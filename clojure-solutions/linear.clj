<<<<<<< HEAD
(defn isSameSize [need & args]
  (every? (fn [x] (== need x)) (mapv count args)))

(defn isVector [v]
  (and (vector? v)
       (every? number? v)))

(defn isMatrix [m]
  (and (vector? m)
       (every? isVector m)
       (apply isSameSize (count (first m)) m)))

(defn forEachV [operation]
  (fn [& args]
    {:pre [(and (every? isVector args)
                 (apply isSameSize (count (first args)) args))]}
    (apply mapv operation args)))

(def v+ (forEachV +))
(def v- (forEachV -))
(def v* (forEachV *))
(def vd (forEachV /))

(defn scalar [& args]
  {:pre [(every? isVector args)]}
  (apply + (reduce (fn [a b] (v* a b)) args))
  )

(defn vecMul [a b]
  (let [cord (fn [fir sec]
               (- (* (nth a fir) (nth b sec)) (* (nth a sec) (nth b fir)))
               )
        ]
    (vector (cord 1 2)
            (cord 2 0)
            (cord 0 1)
            )))

(defn vect [& args]
  {:pre [(and (every? isVector args)
              (apply isSameSize 3 args))]}
  (reduce vecMul args)
  )

;(defn *s [operation ansScalar object]
;    (mapv (partial operation ansScalar) object)
;  )

(defn v*s [vector & scalars]
  {:pre [(and (every? number? scalars) (isVector vector))]}
  (let [ansScalar (reduce * scalars)]
    mapv (partial * ansScalar) vector
    )
  )

(defn forEachM [operation]
  (fn [& args]
    {:pre [(and (every? isMatrix args)
                (apply isSameSize (count (first args)) args)
                )]}
    (apply mapv operation args))
  )

(def m+ (forEachM v+))
(def m- (forEachM v-))
(def m* (forEachM v*))
(def md (forEachM vd))

(defn transpose [matrix]
  {:pre [(isMatrix matrix)]}
  (apply mapv vector matrix)
  )

(defn m*s [matrix & scalars]
  {:pre [(and (every? number? scalars) (isMatrix matrix))]}
  (let [ansScalar (reduce * scalars)]
    mapv (partial v*s ansScalar) matrix
    )
  )

(defn m*v [matrix vector]
  {:pre [(and (isVector vector) (isMatrix matrix))]}
  (mapv (partial scalar vector) matrix)
  )

(defn m*m [& args]
  {:pre [(every? isMatrix args)]}
  (reduce (fn [matrix, matrix2]
            (let [transMatrix2 (transpose matrix2)]
              (mapv (partial m*v transMatrix2) matrix)
              )
            ) args)
  )

;tensors...

(defn tensForm [t]
  (cond
    (number? t) (list 1)
    (vector? t) (
                 (cons (count t) (tensForm (nth t 0)))
                 )
    )
  )

(defn broadcastable? [a b]
  ()
  )

(defn broadcast [a b]
  ()
  )

(defn broadcastAll [args]
  (let [maxTen (
                 tensForm (
                 fn [args]
                 (apply max-key (fn [x] count (tensForm x)) args)
                 ))]
    (mapv (partial broadcast maxTen) args)
    )
  )

(defn forEachTen [operation]
  (fn [& tensors]
    (apply (partial operation) (broadcastAll tensors)))
  )

(defn tb+ forEachTen +)
(defn tb- forEachTen -)
(defn tb* forEachTen *)
(defn tbd forEachTen /)
=======
; Duplicate code, refactor me
(defn v+ [a b] (mapv + a b))
(defn v- [a b] (mapv - a b))
(defn v* [a b] (mapv * a b))
(defn vd [a b] (mapv / a b))
>>>>>>> 2378f839de694a2fe4322fbea7523eb36486ed5e
