#Created by Alonso Angulo Murillo on 20/04/16.
#Copyright © 2016 Alonso Angulo Murillo. All rights reserved.

import RPi.GPIO as GPIO		#inicializo los pines GPIO de la RPi
import time			#inicializo los timers y contadores de la RPi
import pygame			#inicializo la librería para la lectura de los botones del control del PS3

#lado izquierdo PuenteH1 GPIO para motor DC
in1=7
in2=11

#lado derecho PuenteH2 GPIO para motor DC
in5=13
in6=15

GPIO.setmode(GPIO.BCM)		#configuro las salidas de los GPIO con el nombre natural de los pines en vez del orden de  los mismos

#inicializacion motores traccion
GPIO.setup(in1,GPIO.OUT)	#se declaran todos los pines para las entradas de los Puente Hs como salidas
GPIO.setup(in2,GPIO.OUT)
GPIO.setup(in5,GPIO.OUT)
GPIO.setup(in6,GPIO.OUT)

pwmin1=GPIO.PWM(in1,500)	#se declaran todas las salidas anteriores como PWM con una frecuencia de 500 Hz
pwmin2=GPIO.PWM(in2,500)
pwmin5=GPIO.PWM(in5,500)
pwmin6=GPIO.PWM(in6,500)
pwmin1.start(0)			#se inicilizan los PWM con un ciclo de trabajo de 0%
pwmin2.start(0)
pwmin5.start(0)
pwmin6.start(0)

pygame.init()
j = pygame.joystick.Joystick(0)	#se guarda la libreria de JoyStick en j para no volver a escribir todos los comandos mas que poner con j
j.init()			#se inicializa la libreria
print 'Jostick iniciado : %s' % j.get_name()				# se imprime el control de PS3 que esté conectado
apertura=1 								#se inicializa el valor del ciclo de trabajo de la apertura la garra

try:

	while True:
		pygame.event.pump()					#se empieza librería para poder hacer lectura de los botones del control del PS3 como eventos
		if (j.get_axis(1) > 0.2) or (j.get_axis(1) < -0.2):	#adelante y atras, para que funcione solo cuando la palanca izquierda esté a más de 20% de la amplitud total
			if j.get_axis(1) < -0.2:			#para movimiento del eje Y hacia arriba
				CicloDeTrabajo = j.get_axis(1)*(-100) 	#multiplica el valor del la palanca por 100 para conseguir el cilco de trabajo de 0 a 100%
				if CicloDeTrabajo>100:			#si se llegara a pasar de 100% se regresa a 100%
					CicloDeTrabajo=100
				pwmin1.ChangeDutyCycle(0)		#conjunto de ciclos de trabajo para que camione hacia adelante
                        	pwmin2.ChangeDutyCycle(CicloDeTrabajo)
                        	
				pwmin5.ChangeDutyCycle(CicloDeTrabajo)
                                pwmin6.ChangeDutyCycle(0)
                                
			if j.get_axis(1) > 0.2:				#con el movimiento del eje y hacia abajo
				CicloDeTrabajo = j.get_axis(1)*(100)	#se multiplica por 100 para llegar al ciclo de trabajo de 0 a 100 %
                                if CicloDeTrabajo>100:			#si se llegara a pasar de 100% se regresa a 100%
                                        CicloDeTrabajo=100
                                pwmin1.ChangeDutyCycle(CicloDeTrabajo)	#conjunto de PWM para que camine hacia atras
                                pwmin2.ChangeDutyCycle(0)
                                pwmin5.ChangeDutyCycle(0)
                                pwmin6.ChangeDutyCycle(CicloDeTrabajo)
                                
		
		if (j.get_axis(1)> -0.2) and (j.get_axis(1)<0.2) and (j.get_axis(2)<0.2) and (j.get_axis(2)>-0.2):#robot parado si la palanca se encuentra a menos del 20% de su amplitud para darle un juego sin que se mueva
			pwmin1.ChangeDutyCycle(0)			#conjunto de PWM para que el robot se pare completamente
                        pwmin2.ChangeDutyCycle(0)
                        pwmin5.ChangeDutyCycle(0)
                        pwmin6.ChangeDutyCycle(0)
              
		
		if (j.get_axis(2) > 0.2) or (j.get_axis(2) < -0.2):	#giro derecha e izquierda
                        if j.get_axis(2) < -0.2:
                                CicloDeTrabajo = j.get_axis(2)*(-100)	#multiplica el valor del la palanca por 100 para conseguir el cilco de trabajo de 0 a 100%
                                if CicloDeTrabajo>100:			#si se llegara a pasar de 100% se regresa a 100%
                                        CicloDeTrabajo=100
                                pwmin1.ChangeDutyCycle(0)		#conjunto de PWM para que el robot gire a la derecha
                                pwmin2.ChangeDutyCycle(CicloDeTrabajo)
                                pwmin5.ChangeDutyCycle(0)
                                pwmin6.ChangeDutyCycle(CicloDeTrabajo)
                               
                        if j.get_axis(2) > 0.2:
                                CicloDeTrabajo = j.get_axis(2)*(100)	#multiplica el valor del la palanca por 100 para conseguir el cilco de trabajo de 0 a 100%
                                if CicloDeTrabajo>100:			#si se llegara a pasar de 100% se regresa a 100%
                                        CicloDeTrabajo=100
                                pwmin1.ChangeDutyCycle(CicloDeTrabajo)	#conjunto de PWM para que el robot gire a la izquierda
                                pwmin2.ChangeDutyCycle(0)
                                pwmin5.ChangeDutyCycle(CicloDeTrabajo)
                                pwmin6.ChangeDutyCycle(0)
                               
except KeyboardInterrupt:						#se limpia todo el codigo si se interrumpe con Ctrl + C
	GPIO.cleanup()
	pwmin1.stop()
        pwmin2.stop()
    	pwmin5.stop()
        pwmin6.stop()
      
