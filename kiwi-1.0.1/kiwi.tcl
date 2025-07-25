#!/usr/bin/wish
##  KIWI
##
##  Copyright (C) 2003  Universidad Politecnica de Valencia, SPAIN
##
##  Author: Agustin Espinosa Minguet   aespinos@dsic.upv.es
##
##  KIWI is free software;     you can  redistribute it and/or  modify it
##  under the terms of the GNU General Public License  as published by the
##  Free Software Foundation;  either  version 2, or (at  your option) any
##  later version.
##
##  KIWI  is  distributed  in the  hope  that  it will  be   useful,  but
##  WITHOUT  ANY  WARRANTY;     without  even the   implied   warranty  of
##  MERCHANTABILITY  or  FITNESS FOR A  PARTICULAR PURPOSE.    See the GNU
##  General Public License for more details.
##
##  You should have received  a  copy of  the  GNU General Public  License
##  distributed with KIWI;      see file COPYING.   If not,  write to the
##  Free Software  Foundation,  59 Temple Place  -  Suite 330,  Boston, MA
##  02111-1307, USA.



##################
## SECCION COLORES
##################

set qg(color,azulOscuro) #00007d
set qg(color,azulNormal) #0000ff
set qg(color,grisKiwi)   gray60
set qg(color,grisClaro)  gray90
set qg(color,resaltado) #aa0000
set qg(color,destacado) red
set qg(color,seccion) gray90


 
#########################
## SECCION tipos de letra 
#########################



if { [regexp -nocase "x" $tcl_platform(os)] } { 
    set qg(familia) helvetica

    font create standard \
	    -family $qg(familia) -size 12

    font create pequenna \
	    -family $qg(familia) -size 10

    font create visorfont \
	    -family $qg(familia) -size 10

    font create cuadriculafont \
	    -family $qg(familia) -size 10
} else {
    set qg(familia) times

    font create standard \
	    -family $qg(familia) -size 10

    font create pequenna \
	    -family $qg(familia) -size 8

    font create visorfont \
	    -family $qg(familia) -size 8

    font create cuadriculafont \
	    -family $qg(familia) -size 8
}

###################
##  SECCION VALIDAR
###################


set qg(eventosValidos) {
     0 START 
     1 STOP 
     2 DEADLINE 
     3 EXEC-B 
     4 EXEC-E
     5 READY-B
     6 READY-E
     7 LOCK 
     8 UNLOCK 
     9 PRIORITY_CHANGE 
    10 ARROWUP 
    11 BLOCK 
    12 VLINE 
    13 TEXTOVER 
    14 TEXTUNDER
}

proc validarEsEventoCorrecto {ev} {
    global qg

    set t     [lindex $ev 0]
    set clase [lindex $ev 1]
    set linea [lindex $ev 2]

    if { ! [validarEsTiempo $t] } {
	return 0
    }

    if { ! [validarEsEvento $clase] } {
	return 0
    }

    if { ! [validarEsNumero $linea] && ($clase != "VLINE" && $clase != 12) } {
	return 0
    }

    if { $linea < 0 } {
	return 0
    }

    return 1
}
    
proc validarEsEvento {e} {
    global qg

    if { [lsearch -exact $qg(eventosValidos) $e] == -1 } {
	return 0
    } else {
	return 1
    }
}

proc validarEsNumero {v} {

    return [expr ! [catch {expr $v + 1}]]

}

proc validarEsTiempo {t} {

    if { ! [validarEsNumero $t] } {
	return 0
    }

    if { $t < 0 || $t >= 9999.999999999 } {
	return 0
    } else {
	return 1
    }
}


######################
##  SECCION AUXILIARES
######################

    set qg(nombreDe,0)  START
    set qg(nombreDe,1)  STOP
    set qg(nombreDe,2)  DEADLINE
    set qg(nombreDe,3)  EXEC-B
    set qg(nombreDe,4)  EXEC-E
    set qg(nombreDe,5)  READY-B
    set qg(nombreDe,6)  READY-E
    set qg(nombreDe,7)  LOCK
    set qg(nombreDe,8)  UNLOCK
    set qg(nombreDe,9)  PRIORITY_CHANGE
    set qg(nombreDe,10) ARROWUP
    set qg(nombreDe,11) BLOCK
    set qg(nombreDe,12) VLINE
    set qg(nombreDe,13) TEXTOVER
    set qg(nombreDe,14) TEXTUNDER
    set qg(nombreDe,100) EXEC
    set qg(nombreDe,101) READY
    set qg(nombreDe,102) ALLTEXT
    set qg(nombreDe,START)     START 
    set qg(nombreDe,STOP)      STOP
    set qg(nombreDe,DEADLINE)  DEADLINE
    set qg(nombreDe,EXEC-B)    EXEC-B
    set qg(nombreDe,EXEC-E)    EXEC-E
    set qg(nombreDe,READY-B)   READY-B
    set qg(nombreDe,READY-E)   READY-E
    set qg(nombreDe,LOCK)      LOCK
    set qg(nombreDe,UNLOCK)    UNLOCK
    set qg(nombreDe,PRIORITY_CHANGE)   PRIORITY_CHANGE
    set qg(nombreDe,ARROWUP) ARROWUP
    set qg(nombreDe,BLOCK)     BLOCK
    set qg(nombreDe,VLINE)     VLINE
    set qg(nombreDe,TEXTOVER)    TEXTOVER
    set qg(nombreDe,TEXTUNDER)  TEXTUNDER
    set qg(nombreDe,EXEC)      EXEC
    set qg(nombreDe,READY)     READY
    set qg(nombreDe,ALLTEXT)  ALLTEXT


    set qg(idDe,START)      0
    set qg(idDe,STOP)       1
    set qg(idDe,DEADLINE)   2
    set qg(idDe,EXEC-B)     3
    set qg(idDe,EXEC-E)     4
    set qg(idDe,READY-B)    5
    set qg(idDe,READY-E)    6
    set qg(idDe,LOCK)       7
    set qg(idDe,UNLOCK)     8
    set qg(idDe,PRIORITY_CHANGE)    9
    set qg(idDe,ARROWUP) 10
    set qg(idDe,BLOCK)     11
    set qg(idDe,VLINE)     12
    set qg(idDe,TEXTOVER)    13
    set qg(idDe,TEXTUNDER)  14
    set qg(idDe,EXEC)     100
    set qg(idDe,READY)    101
    set qg(idDe,ALLTEXT)  102
    set qg(idDe,0)   0
    set qg(idDe,1)   1 
    set qg(idDe,2)   2
    set qg(idDe,3)   3
    set qg(idDe,4)   4
    set qg(idDe,5)   5
    set qg(idDe,6)   6
    set qg(idDe,7)   7
    set qg(idDe,8)   8
    set qg(idDe,9)   9
    set qg(idDe,10) 10
    set qg(idDe,11) 11
    set qg(idDe,12) 12
    set qg(idDe,13) 13
    set qg(idDe,14) 14
    set qg(idDe,100)  100
    set qg(idDe,101)  101
    set qg(idDe,102)  102

set qg(eventosPorNombre) {EXEC READY START STOP LOCK UNLOCK BLOCK DEADLINE PRIORITY_CHANGE ARROWUP TEXTOVER TEXTUNDER ALLTEXT VLINE}

proc formatea {val args} {

    global qg

    if { $args == "" } {
	set val [format "%.$qg(posDecimales)f" $val ]
    } else {
	set val [format "%.${args}f" $val ]
    }

    set dot " "
    set decpos [string first "." $val ]

    if { $decpos == -1 } {
	return $val
    }

    set len [string length $val]
    
    set partedec ""
    set j 0
    for {set i [expr $decpos + 1]} {$i < $len} {incr i} {
	if { [expr $j % 3] == 0 && $j != 0 } {
	    set partedec $partedec$dot
	}
	set partedec "$partedec[string index $val $i]"
	incr j
    }
    
    set j 0
    set parteent ""
    for {set i [expr $decpos - 1]} {$i >= 0 } {incr i -1} {
	if { [expr $j % 3] == 0 && $j != 0 } {
	    set parteent $dot$parteent
	}
	set parteent "[string index $val $i]$parteent"
	incr j
    }
   
    return $parteent.$partedec
}



proc kiwiError {s} {
    tk_dialog .errror "Kiwi Error"  $s "" "" "Accept"
}



######################
##  SECCION postscript
######################

proc postscriptCrea {} {

    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set fich [tk_getSaveFile -title "Create eps file"  \
	    -filetypes { {{Eps files} {*.eps}}  {{All Files} {*}} } -initialfile "" \
	    -defaultextension .eps ] 
    if { $fich == "" } {
	return
    }

    set IZ 80
    set DER 0

    set c .visor.tareasVisor.c
    set desde $qg(desde)

    set primerTick $qg(primeroVisible)
    set canvasx1 0
    set canvasx2 [visorUltimoPixel]

    set anchoFoto \
	    [expr $canvasx2 + $IZ + $DER + $qg(tamannoSimbolo) + 2 - $canvasx1]
    
    set X1 [expr $canvasx1 - $qg(tamannoSimbolo) - 2]
    set X2 [expr $X1 - $IZ]

    set coords [dibujarCoordenadas $qg(numeroDeLineas) 0]

    set Y1 0
    set Y2 [expr [lindex $coords 3] + 2]

    $c create rect $X1 $Y1 $X2 $Y2 -fill white -outline white -tag postscript
    set psX1 $X2
    set psX2 [expr $psX1 + $anchoFoto]
    set psY1 0
    set psY2 [lindex [$c cget -scrollregion] 3]

    $c create line $X1 $Y1 $X1 $psY2 -fill black -tag postscript

    set altoFoto $psY2

    set X [expr $X1 - 3]
    for {set i 0} {$i < $qg(numeroDeLineas) } {incr i} {
	set Y \
		[expr [lindex [dibujarCoordenadas $i $desde] 3] + 1]
	$c create text \
		$X \
		$Y \
		-anchor se -text [lindex $qg(nombresDeLineas) $i] \
		-font standard \
		-tag postscript
	
    }

    set X1 [expr $psX2 - $DER]
    set X2 $psX2
    set Y1 $psY1 
    set Y2 $psY2

    $c create rect $X1 $Y1 $X2 $Y2 -fill white -outline white -tag postscript
    $c create line $X1 $Y1 $X1 $Y2 -fill black -tag postscript
    

    set X [expr $psX1 + $IZ + 5]
    set Y [expr $psY2 - 2] 

    $c create text $X $Y \
	    -anchor sw -text "Width  [formatea $qg(anchoVisible)] s" \
	    -font cuadriculafont -tag postscript

    set X [expr $psX2 - $DER - 5]
    $c create text $X $Y \
	    -anchor se -text "Grid  [formatea $qg(cada)] s" \
	    -font cuadriculafont -tag postscript


    set item [$c create line $psX1 $psY1 $psX2 $psY1 $psX2 $psY2 $psX1 $psY2 $psX1 $psY1 -fill black -tag postscript]

    update
    $c postscript -pageheight 10c -file $fich \
	    -x $psX1 -width $anchoFoto \
	    -y 0 -height $altoFoto
    $c delete postscript
    update
}


##################
## SECCION GUARDAR
##################



proc guardarFiltrarTraza {fd} {
    global qg 
    
    foreach lin $qg(cabecera) {
	puts $fd $lin
    }
    foreach lin $qg(trazaGuardada) {
	guardarFiltrarUnaLinea $lin $fd
    }
}



proc guardarFiltrarUnaLinea {lin fd} {
    global qg 

    set t    [lindex $lin 0]
    set tipo [lindex $lin 1]
    
    if { $t < $qg(from) } return
    if { $t > $qg(to) } return
    if { ! [panelDetallesFiltrado $tipo] } return

    set arg1 [lindex $lin 2]
    set arg2 [lindex $lin 3]
    set arg3 [lindex $lin 4]

    set t [format "%.9f" [expr $t + $qg(incremento)]]

    puts $fd "$t $tipo $arg1 $arg2 $arg3"
}



proc guardarCreaFichero {} {
    global qg  

    
    set f [tk_getSaveFile -title "Save Current Trace As"  \
	    -filetypes { {{Trace Files} {.ktr}} {{All Files} {*}} } \
	    -defaultextension .ktr]

    if {$f != ""} {
	set fd [open $f "w"]
	guardarFiltrarTraza $fd
	close $fd
	destroy .g
    } else {
    }
}



proc guardarCreaTraza {} {
    global qg

    catch {destroy .g}
    toplevel .g 
    wm title .g "Filter Events"
    wm transient .g .
    
    grab .g
    frame .g.l
    frame .g.r
    frame .g.b

    grid .g.l .g.r -row 0  -padx 10 -pady 10
    grid .g.b -row 1 -columnspan 2 -padx 10 -pady 10

    set qg(from) [format "%.$qg(posDecimales)f" $qg(desde)]
    label .g.l.from_label -text "From Tick"
    
    entry .g.l.from -width 24 -textvariable qg(from)
    
    set qg(to) [format "%.$qg(posDecimales)f" [expr $qg(desde) + $qg(duracion)]]
    label .g.l.to_label -text "To Tick" -justify r
    entry .g.l.to -width 24 -textvariable qg(to)
    
    

    set qg(incremento) [format "%.$qg(posDecimales)f" $qg(desde)]
    label .g.l.incremento_label -text "Increment" -justify r
    entry .g.l.incremento -width 24 -textvariable qg(incremento)
    

    grid .g.l.from_label   .g.l.from   -row 0 -sticky e
    grid .g.l.to_label     .g.l.to     -row 1 -sticky e
    grid .g.l.incremento_label .g.l.incremento -row 2 -sticky e
    

    
    button .g.b.save -command "guardarCreaFichero" -text "Save As"
    button .g.b.cancel -command "destroy .g" -text "Cancel"
    
    grid .g.b.save .g.b.cancel -row 2
}



###################
## SECCION INTERFAZ
###################



proc interfazInfo {s} {

    .botones.info configure -text $s
}



proc interfazPararTraza {} {
    global qg

    if { $qg(estado,trazacargada) && !$qg(estado,dibujando) } {
	return
    }

    set qg(hemosParado) 1

}



proc interfazCrea {} {
    global qg

    ## Inicializacion 

    set qg(zoomXmin) -6
    set qg(zoomXmax) 38
    set qg(zoomYmin) 1
    set qg(zoomYmax) 48
    

    set qg(hemosParado) 0
    set qg(ficheroDatos) ""
    set qg(trazaGuardada) {}	
    set qg(prioVisor) ""
    set qg(ultimoVisible) 0
    set qg(mostrarPocoAPoco) 0
    set qg(noRedimensionar) 1
    set qg(estado,trazacargada) 0
    set qg(estado,trazapresente) 0
    set qg(estado,leyendofichero) 0
    set qg(estado,dibujando) 0
    set qg(holgura) 8
    parametrosPorDefecto
    parametrosDerivados

    esquemasCreaEsquemas


    ## Titulo

    wm title . "Kiwi 1.0.1"


    ## Asignamos el peso a cada una de las celdas
    
    grid rowconfigure . 0 -weight 0
    grid rowconfigure . 1 -weight 1 
    grid rowconfigure . 2 -weight 0
    grid columnconfigure . 0 -weight 1
    

    ## creamos los marcos principales

    catch {destroy .botones}
    catch {destroy .botonesmov}
    catch {destroy .visor}
    catch {destroy .estado}

    set b .botones
    set bm .botonesmov
    set fondo .fondo
    set v .visor
    set e .estado
    
    frame $b -borderwidth 2 -relief groove -bg $qg(color,grisKiwi)
    grid $b -row 0 -column 0 -sticky nwse
    
    frame $v -borderwidth 2 -relief groove
    grid $v -row 1 -column 0 -sticky nswe 
    grid rowconfigure $v 0 -weight 1
    grid columnconfigure $v 0 -weight 1

    frame $bm -borderwidth 2 -relief groove -bg $qg(color,grisKiwi)
    grid $bm -row 2 -column 0 -sticky nwse

    frame $fondo -borderwidth 2 -relief groove -bg $qg(color,grisKiwi)
    grid $fondo -row 3 -column 0 -sticky nwse

    frame $e -borderwidth 2 -relief groove -bg $qg(color,grisKiwi)

    frame $v.tareasVisor -relief groove -borderwidth 2
    
    grid $v.tareasVisor -row 0 -column 0 -sticky wens -pady 1
    grid rowconfigure $v.tareasVisor 0 -weight 1
    grid columnconfigure $v.tareasVisor 0 -weight 1

    frame $v.herramientas -relief groove -borderwidth 2 -bg $qg(color,grisKiwi)
    grid  $v.herramientas -row 0 -column 1 -sticky ns -pady 1

    ## Creamos el resto de la interfaz

    interfazIniBotones 
    interfazIniBotonesMovimiento
    interfazIniBotonesFondo

    set qg(tareasVisor) \
	    [visorCrea $v.tareasVisor]

    creaPaneles
    interfazIniHerramientas

    botonesIniciales

    ## Asociacion de eventos


    bind .fondo.miniatura \
	    <Motion> "miniaturaMovimientoEn %x %y"
    bind .fondo.miniatura \
	    <Double-Button-1> "miniaturaSeleccionEn %x %y"

    bind $qg(tareasVisor) \
	    <Motion> "visorMovimientoEn %x %y"

    bind $qg(tareasVisor) \
	    <2> "desplazarIr"
    bind $qg(tareasVisor) \
	    <Double-Button-1> "visorIr %x %y"
    bind $qg(tareasVisor) \
	    <3> "marcasComienzaDrag  $qg(tareasVisor) %x %y"
    bind $qg(tareasVisor) \
	    <B3-Motion> "marcasDrag  $qg(tareasVisor) %x %y"
    bind $qg(tareasVisor) \
	    <ButtonRelease-3> "marcasFinDrag $qg(tareasVisor)"
    set nunits 1

    bind . <Prior>       "desplazarRetrocedePagina"
    bind . <Next>        "desplazarAvanzaPagina"
    bind . <Left>        "desplazarRetrocedeBloque"
    bind . <Right>       "desplazarAvanzaBloque"
    bind . <Shift-Left>  "desplazarRetrocedePixel"
    bind . <Shift-Right> "desplazarAvanzaPixel"
    bind . <Up>    "visorScrollVertical -1"
    bind . <Down>  "visorScrollVertical 1"
    bind . <Home>  "desplazarAlPrincipio"
    bind . <End>   "desplazarAlFinal"
    bind . <Delete> "marcasBorrarTodas"
    bind . <space> "dibujarRedibuja"
    bind . <Return> "dibujarRedibuja"
    bind . <KP_Enter> "dibujarRedibuja"
    bind . <KP_Add> "interfazMasZoom"
    bind . <KP_Subtract> "interfazMenosZoom"
    bind . <plus> "interfazMasZoom"
    bind . <minus> "interfazMenosZoom"
    bind . <Shift-KP_Add> "interfazMasZoomY"
    bind . <Shift-KP_Subtract> "interfazMenosZoomY"
    bind . <Shift-plus> "interfazMasZoomY"
    bind . <Shift-minus> "interfazMenosZoomY"
    bind . <Control-g> "desplazarIr"

    # tamanno de la ventana

    wm geometry . 800x540

}


proc interfazMasZoom {} {
    global qg
    
    if { $qg(anchuraDeTickInterfaz) == $qg(zoomXmax) } {
	return
    }

    incr qg(anchuraDeTickInterfaz)
}


proc interfazMenosZoom {} {
    global qg
    
    if { $qg(anchuraDeTickInterfaz) == $qg(zoomXmin) } {
	return
    }

    incr qg(anchuraDeTickInterfaz) -1
    
}

proc interfazMasZoomY {} {
    global qg
    
    incr qg(alturaDeTickInterfaz)
}


proc interfazMenosZoomY {} {
    global qg
    
    incr qg(alturaDeTickInterfaz) -1
    
}

proc interfazIniHerramientas {} {
    global qg

    set f .visor.herramientas

    set qg(iconoDe,$f.paneleventos)     $qg(imagen,paneleventos)
    set qg(icono2De,$f.paneleventos)    $qg(imagen,paneleventos2)
    set qg(iconoDe,$f.paneldetalles)    $qg(imagen,paneldetalle)
    set qg(icono2De,$f.paneldetalles)   $qg(imagen,paneldetalle2)
    set qg(iconoDe,$f.arriba)           $qg(imagen,arriba)
    set qg(icono2De,$f.arriba)          $qg(imagen,arriba2)
    set qg(iconoDe,$f.abajo)            $qg(imagen,abajo)
    set qg(icono2De,$f.abajo)           $qg(imagen,abajo2)

    set botones {paneleventos paneldetalles arriba abajo}
    

    set j 0
    foreach i $botones {
	button $f.$i -borderwidth 2  \
		-bg $qg(color,grisKiwi) -activebackground $qg(color,grisKiwi) -highlightthickness 0
	$f.$i configure -width 24 -height 14
	botonesSaleDeBoton $f.$i 
	bind $f.$i <Enter> "botonesEntraEnBoton %W"
	bind $f.$i <Leave> "botonesSaleDeBoton %W"
    }
    

    $f.paneleventos configure -command "clickBotonPanel eventos"
    grid $f.paneleventos -row 0 -pady 3 -sticky nw

    bind . <Control-e> "clickBotonPanel eventos"

    $f.paneldetalles configure -command "clickBotonPanel detalles"
    grid $f.paneldetalles -row 1 -pady 3 -sticky nw

    bind . <Control-v> "clickBotonPanel detalles"

    frame $f.centro -bg $qg(color,grisKiwi)
    grid $f.centro -row 9 -sticky ns
    grid rowconfigure $f 9 -weight 1
    
    $f.arriba configure -command "visorScrollVertical -1"
    grid $f.arriba -row 10 -pady 3 -sticky nw
    
    $f.abajo configure -command "visorScrollVertical 1"
    grid $f.abajo -row 11 -pady 3 -sticky nw
    

}

proc interfazIniBotones {} {

    global qg

    set b .botones

    iniImagenes

    set qg(iconoDe,$b.abrir)     $qg(imagen,abrir)
    set qg(icono2De,$b.abrir)    $qg(imagen,abrir2)
    set qg(iconoDe,$b.guardar)     $qg(imagen,guardar)
    set qg(icono2De,$b.guardar)    $qg(imagen,guardar2)
    set qg(iconoDe,$b.apariencia.redibujar)      $qg(imagen,pincel)
    set qg(icono2De,$b.apariencia.redibujar)     $qg(imagen,pincel2)
    set qg(iconoDe,$b.apariencia.esquema)  $qg(imagen,iris)
    set qg(icono2De,$b.apariencia.esquema) $qg(imagen,iris2)
    set qg(iconoDe,$b.stop)      $qg(imagen,stop)
    set qg(icono2De,$b.stop)     $qg(imagen,stop2)
    set qg(iconoDe,$b.ejecutar)  $qg(imagen,ejecutar)
    set qg(icono2De,$b.ejecutar) $qg(imagen,ejecutar2)
    set qg(iconoDe,$b.ps)        $qg(imagen,grabar)
    set qg(icono2De,$b.ps)       $qg(imagen,grabar2)
    

    set botones {abrir guardar ps ejecutar stop }
    
    set j 0
    foreach i $botones {
	incr j
	button $b.$i -borderwidth 2  \
		-bg $qg(color,grisKiwi) -activebackground $qg(color,grisKiwi) -highlightthickness 0
	if { $qg(iconoDe,$b.$i) != ""} {
	    $b.$i configure -width 24 -heigh 20
	} else {
	    $b.$i configure -text $qg(textoDe,$b.$i) -font standard
	}
	botonesSaleDeBoton $b.$i 
	grid $b.$i -row 1 -column $j -sticky nw -padx 3 -pady 5
	bind $b.$i <Enter> "botonesEntraEnBoton %W"
	bind $b.$i <Leave> "botonesSaleDeBoton %W"
    }
    
    $b.abrir configure    -command "abrirFichero"
    $b.ejecutar configure -command "reproducirTraza"
    $b.stop configure     -command "interfazPararTraza"
    $b.guardar configure  -command "guardarCreaTraza"
    $b.ps configure       -command "postscriptCrea"

    bind . <Control-o> "abrirFichero"
    bind . <Control-p> "reproducirTraza"
    bind . <Control-r> "postscriptCrea"
    bind . <Escape>    "interfazPararTraza"
    bind . <Control-s>    "guardarCreaTraza"

    incr j
    label $b.info -width 30 -bg $qg(color,grisKiwi) -fg white -font pequenna -anchor w -padx 10

    grid $b.info -row 1 -column [expr $j + 1] -sticky nsw -padx 2 -pady 5

    incr j
    grid columnconfigure $b $j  -weight 1

    frame $b.apariencia -bg $qg(color,grisKiwi) -borderwidth 1 -relief groove
    grid $b.apariencia -row 1 -column [expr $j + 1] -sticky nw -padx 2 -pady 5
    incr j

    entry $b.apariencia.anchoDeTick -borderwidth 1 \
	    -bg $qg(color,grisClaro) -highlightthickness 0 -width 5 \
	    -textvariable qg(anchuraDeTickInterfaz) \
	    -font pequenna


    entry $b.apariencia.altoDeTick -borderwidth 1 \
	    -bg $qg(color,grisClaro) -highlightthickness 0 -width 5 \
	    -textvariable qg(alturaDeTickInterfaz) \
	    -font pequenna

    scale $b.apariencia.horizontal -from $qg(zoomXmin) -to $qg(zoomXmax)\
	    -orient horizontal \
	    -showvalue no \
	    -width 6 \
	    -length 100 \
	    -borderwidth 1 \
	    -bg $qg(color,grisKiwi) -activebackground $qg(color,azulOscuro) -highlightthickness 0 -troughcolor $qg(color,grisClaro) \
	    -variable qg(anchuraDeTickInterfaz)

    
    scale $b.apariencia.vertical -from $qg(zoomYmin) -to $qg(zoomYmax) \
	    -orient horizontal \
	    -showvalue no \
	    -width 6 \
	    -length 100 \
	    -borderwidth 1 \
	    -bg $qg(color,grisKiwi) -activebackground $qg(color,azulOscuro) \
	    -highlightthickness 0 -troughcolor $qg(color,grisClaro) \
	    -variable qg(alturaDeTickInterfaz)
    
    button $b.apariencia.redibujar -borderwidth 2 -width 24 \
	    -heigh 20 -bg $qg(color,grisKiwi) \
	    -activebackground $qg(color,grisKiwi) -highlightthickness 0 \
	    -command "dibujarRedibuja"
    botonesSaleDeBoton $b.apariencia.redibujar 
    bind $b.apariencia.redibujar <Enter> "botonesEntraEnBoton %W"
    bind $b.apariencia.redibujar <Leave>  "botonesSaleDeBoton %W"

    menubutton $b.apariencia.esquema -borderwidth 2 -width 24 \
	    -heigh 20 -bg $qg(color,grisKiwi) \
	    -activebackground $qg(color,grisKiwi) -highlightthickness 0

    menu $b.apariencia.esquema.menu \
	    -bg $qg(color,grisKiwi) -activebackground $qg(color,grisKiwi) -tearoff false \
	    -font pequenna \
	    -activebackground $qg(color,grisKiwi)\
	    -borderwidth 1
    
    foreach i [lsort $qg(Esquemas)] {

	$b.apariencia.esquema.menu add radiobutton \
		-label "$i" -command "esquemasCambiaEsquemaActual" \
		-variable qg(esquema) -value $i
    }


    $b.apariencia.esquema configure -menu $b.apariencia.esquema.menu
    botonesSaleDeBoton $b.apariencia.esquema 
    bind $b.apariencia.esquema <Enter> "botonesEntraEnBoton %W"
    bind $b.apariencia.esquema <Leave>  "botonesSaleDeBoton %W"

    label $b.apariencia.widhteti  -text "Zoom X" -font pequenna -bg $qg(color,grisKiwi)
    label $b.apariencia.heighteti -text "Zoom Y" -font pequenna -bg $qg(color,grisKiwi)

    grid $b.apariencia.widhteti    -row 0 -column 0 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.anchoDeTick -row 0 -column 1 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.heighteti   -row 1 -column 0 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.altoDeTick  -row 1 -column 1 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.horizontal  -row 0 -column 2 -sticky ns -padx 1 -pady 1
    grid $b.apariencia.vertical    -row 1 -column 2 -sticky ns -padx 1 -pady 1

    grid $b.apariencia.esquema -row 0 -column 3 -rowspan 2 \
	    -sticky ns -padx 3 -pady 1
    grid $b.apariencia.redibujar -row 0 -column 4 -rowspan 2 \
	    -sticky ns -padx 3 -pady 1

}


proc interfazIniBotonesMovimiento {} {

    global qg

    set b .botonesmov

    iniImagenes


    set qg(iconoDe,$b.avpixel)    $qg(imagen,avpixel)
    set qg(icono2De,$b.avpixel)   $qg(imagen,avpixel2)
    set qg(textoDe,$b.avpixel)    ""

    set qg(iconoDe,$b.avbloque)   $qg(imagen,avbloque)
    set qg(icono2De,$b.avbloque)  $qg(imagen,avbloque2)
    set qg(textoDe,$b.avbloque)   ""

    set qg(iconoDe,$b.avpag)      $qg(imagen,avpag)
    set qg(icono2De,$b.avpag)     $qg(imagen,avpag2)
    set qg(textoDe,$b.avpag)      ""
    
    set qg(iconoDe,$b.retpixel)   $qg(imagen,retpixel)
    set qg(icono2De,$b.retpixel)  $qg(imagen,retpixel2)
    set qg(textoDe,$b.retpixel)   ""

    set qg(iconoDe,$b.retbloque)   $qg(imagen,retbloque)
    set qg(icono2De,$b.retbloque)  $qg(imagen,retbloque2)
    set qg(textoDe,$b.retbloque)   ""


    set qg(iconoDe,$b.retpag)     $qg(imagen,retpag)
    set qg(icono2De,$b.retpag)    $qg(imagen,retpag2)
    set qg(textoDe,$b.retpag)     ""
    
    
    set qg(iconoDe,$b.begin)     $qg(imagen,principio)
    set qg(icono2De,$b.begin)    $qg(imagen,principio2)
    set qg(textoDe,$b.begin)     ""
    
    set qg(iconoDe,$b.end)     $qg(imagen,final)
    set qg(icono2De,$b.end)    $qg(imagen,final2)
    set qg(textoDe,$b.end)     ""
    
    set qg(iconoDe,$b.go)      $qg(imagen,ir)
    set qg(icono2De,$b.go)     $qg(imagen,ir2)
    set qg(textoDe,$b.go)      ""
     
    set qg(iconoDe,$b.del)      $qg(imagen,borrar)
    set qg(icono2De,$b.del)     $qg(imagen,borrar2)
    set qg(textoDe,$b.del)      ""
     



    set botones {begin end retpixel retbloque retpag avpixel avbloque avpag go del}
    

    set j 0
    foreach i $botones {
	incr j
	button $b.$i -borderwidth 2  \
		-bg $qg(color,grisKiwi) -activebackground $qg(color,grisKiwi) -highlightthickness 0
	if { $qg(iconoDe,$b.$i) != ""} {
	    $b.$i configure -width 24 -height 14
	} else {
	    $b.$i configure -text $qg(textoDe,$b.$i) -font standard 
	}
	botonesSaleDeBoton $b.$i 
	bind $b.$i <Enter> "botonesEntraEnBoton %W"
	bind $b.$i <Leave> "botonesSaleDeBoton %W"
    }
    

    label $b.tickActual -borderwidth 1 -relief sunken -width 20 \
	    -font pequenna -bg $qg(color,grisClaro)
    set qg(etiquetaDeTick) $b.tickActual

    entry $b.iraltick -borderwidth 1 \
	    -bg $qg(color,grisClaro) -highlightthickness 0 -width 20 \
	    -textvariable qg(iraltick) \
	    -font pequenna

    bind $b.iraltick <Return> "desplazarIr"
    bind $b.iraltick <KP_Enter> "desplazarIr"

    grid $b.iraltick -row 1 -column $j -sticky w -padx 2 -pady 5

    $b.retpixel  configure -command "desplazarRetrocedePixel"
    $b.retbloque configure -command "desplazarRetrocedeBloque"
    $b.retpag    configure -command "desplazarRetrocedePagina"
    $b.avpixel   configure -command "desplazarAvanzaPixel"
    $b.avbloque  configure -command "desplazarAvanzaBloque"
    $b.avpag     configure -command "desplazarAvanzaPagina"
    $b.begin     configure -command "desplazarAlPrincipio"
    $b.end       configure -command "desplazarAlFinal"
    $b.go        configure -command "desplazarIr"
    $b.del       configure -command "marcasBorrarTodas"


    grid $b.begin      -row 1 -column 1  -sticky nw -padx 3 -pady 5
    grid $b.retpag     -row 1 -column 2  -sticky nw -padx 3 -pady 5
    grid $b.retbloque  -row 1 -column 3  -sticky nw -padx 3 -pady 5
    grid $b.retpixel   -row 1 -column 4  -sticky nw -padx 3 -pady 5

    grid $b.tickActual -row 1 -column 5  -sticky nw -padx 3 -pady 9
    grid $b.go         -row 1 -column 6  -sticky nw -padx 3 -pady 5
    grid $b.iraltick   -row 1 -column 7  -sticky nw -padx 3 -pady 9
    grid $b.del        -row 1 -column 8  -sticky nw -padx 3 -pady 5

    grid $b.avpixel    -row 1 -column 9  -sticky ne -padx 3 -pady 5
    grid $b.avbloque   -row 1 -column 10 -sticky ne -padx 3 -pady 5
    grid $b.avpag      -row 1 -column 11 -sticky ne -padx 3 -pady 5
    grid $b.end        -row 1 -column 12 -sticky ne -padx 3 -pady 5



}

proc interfazIniBotonesFondo {} {
    global qg

    set b .fondo

    canvas $b.miniatura -scrollregion "0 0 1600 20" \
	    -bg $qg(color,grisClaro) -height 20 -width 200 -relief groove -borderwidth 1
    
    $b.miniatura xview moveto 0.0
    $b.miniatura yview moveto 0.0

    label $b.begineti -borderwidth 0 -width 5 -font pequenna -text First -bg $qg(color,grisKiwi)
    label $b.endeti   -borderwidth 0 -width 5 -font pequenna -text Last -bg $qg(color,grisKiwi)
    label $b.begin -borderwidth 1 -relief sunken -width 22 -font pequenna -bg $qg(color,grisClaro)
    label $b.end   -borderwidth 1 -relief sunken -width 22 -font pequenna -bg $qg(color,grisClaro)

    label $b.widtheti -borderwidth 0 -width 5 -font pequenna -text Width -bg $qg(color,grisKiwi)
    label $b.grideti   -borderwidth 0 -width 5 -font pequenna -text Grid -bg $qg(color,grisKiwi)
    label $b.width -borderwidth 1 -relief sunken -width 22 -font pequenna -bg $qg(color,grisClaro)
    label $b.grid   -borderwidth 1 -relief sunken -width 22 -font pequenna -bg $qg(color,grisClaro)

    grid $b.begineti  -row 1 -column 1 -sticky nsw -padx 0 -pady 0 
    grid $b.begin     -row 1 -column 2 -sticky nw -padx 3 -pady 3
    grid $b.endeti    -row 2 -column 1 -sticky nsw -padx 0 -pady 0     
    grid $b.end       -row 2 -column 2 -sticky ne -padx 3 -pady 3

    grid $b.miniatura -row 1 -rowspan 2 -column 3 -sticky wens -padx 3 -pady 3

    grid $b.widtheti  -row 1 -column 4 -sticky nsw -padx 0 -pady 0 
    grid $b.width     -row 1 -column 5 -sticky nw -padx 3 -pady 3
    grid $b.grideti   -row 2 -column 4 -sticky nsw -padx 0 -pady 0 
    grid $b.grid      -row 2 -column 5 -sticky nw -padx 3 -pady 3

    grid columnconfigure $b 3 -weight 9
    
    
}


proc interfazVerPrimero {p} {
    .fondo.begin configure -text $p
}

proc interfazVerUltimo {p color} {
    if { $color == ""} {
	set color black
    }
    .fondo.end configure -text $p -fg $color
}

proc interfazVerAncho {p} {
    .fondo.width configure -text $p
}

proc interfazVerGrid {p} {
    .fondo.grid configure -text $p
}


################
## SECCION VISOR
################
    
proc visorCrea {f} {

    global qg


    set c $f.c
    set n $f.n


    set xscroll 1
    canvas $c -scrollregion "0 0 1600 4000" \
	    -width 1600 -height 1600 \
	    -borderwidth 0 -background white -highlightthickness 0\
	    -xscrollincrement 1 \
	    -yscrollincrement 1 \
	    -relief groove \
	    -xscrollcommand "visorRedimensionEnVisor " 
    

    canvas $n -scrollregion "0 0 80 4000" \
	    -width 80 -height 1600 \
	    -borderwidth 0 -highlightthickness 0 \
	    -yscrollincrement 1 \
	    -background white -relief groove -borderwidth 2

    grid rowconfigure $f 0 -weight 1
    grid rowconfigure $f 1 -weight 0
    grid rowconfigure $f 2 -weight 0
    grid columnconfigure $f 0 -weight 0
    grid columnconfigure $f 1 -weight 1

    grid $n    -row 0 -column 0 -sticky ns
    grid $c    -row 0 -column 1 -sticky nwse

    $c xview moveto 0.0
    $c yview moveto 0.0

    return $c
}




proc visorRedimensionEnVisor {b e} {
    global qg


    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    if { $qg(noRedimensionar) } {
	set qg(noRedimensionar) 0
	return
    }

    set qg(mostrarPocoAPoco) 0
    set panelActual $qg(panelActual)
    if { $qg(panelActual) != "" } {
	ocultaPanel $qg(panelActual)
	muestraPanel $panelActual
    } 
    dibujarRefresca
    desplazarAsignaCentro
    panelEventosRefresca

}


proc visorScrollVertical {n} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c .visor.tareasVisor.c
    
    set yview [$c yview]
    if { [lindex $yview 0] == 0 && [lindex $yview 1] == 1 } {
	return
    }
    
    if { $n == 1 } {
	set n $qg(separacionEntreLineas) 
    } else {
	set n [expr -$qg(separacionEntreLineas)]
    }
    set qg(noRedimensionar) 1
    .visor.tareasVisor.c yview scroll $n units
    .visor.tareasVisor.n yview scroll $n units
    posicionaPanel
}

proc visorLimpia {} {
    .visor.tareasVisor.c delete traza
    .visor.tareasVisor.c delete cuadricula
    .visor.tareasVisor.n delete all

    visorInvisibles
}


proc visorEstableceAltura {} {
    global qg

    set Y2 [expr ($qg(numeroDeLineas) + 2.5) * $qg(separacionEntreLineas)]
    set qg(alturaVisor) $Y2
    .visor.tareasVisor.c configure \
	    -scrollregion "0 0 1600 $Y2" 

    .visor.tareasVisor.n configure \
	    -scrollregion "0 0 80 $Y2"

    set qg(noRedimensionar) 1
}


proc visorInvisibles {} {
    global qg

    ## Creamos items invisibles para poder asi situar
    ## en capas los objetos de la representacion
    ##

    set c $qg(tareasVisor)


    $c create rect -100 -100 -200 -200\
	    -tags cuadricula
    $c create rect -100 -100 -200 -200\
	    -tags ejecucion
    $c create rect -100 -100 -200 -200\
	    -tags preparada
    $c create rect -100 -100 -200 -200\
	    -tags comienza
    $c create rect -100 -100 -200 -200\
	    -tags termina
    $c create rect -100 -100 -200 -200\
	    -tags plazo
    $c create rect -100 -100 -200 -200\
	    -tags posicionir

}


proc visorIr {x y} {

    global qg

    set c $qg(tareasVisor)

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set x  [$c canvasx $x]

    set tick \
	    [expr $x / $qg(anchuraDeTick)]

    set tick [expr $tick + $qg(primeroVisible)]

    if { $tick < $qg(desde) } return
    if { $tick > $qg(final) } return

    set qg(iraltick) [format "%.$qg(posDecimales)f" $tick]
    desplazarIr
    if { $qg(panelActual) == "eventos" } {
	panelEventosRefresca
    }
}



proc visorMovimientoEn {x y} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c $qg(tareasVisor)

    set x  [$c canvasx $x]

    set tick \
	    [expr $x / $qg(anchuraDeTick)]

    set tick [expr $tick + $qg(primeroVisible)]

    if { $tick < $qg(desde) } return
    if { $tick > [expr $qg(duracion)+$qg(desde)] } return

    $qg(etiquetaDeTick) configure -text [formatea $tick]
    set qg(etiquetaDeTickValor) $tick
}


proc visorUltimoPixel {} {
    global qg

    set c $qg(tareasVisor)

    set e [lindex [$c xview] 1]

    return [expr 1600 * $e - $qg(anchoPanelActual)]
}

proc visorIntervaloVisible {} {
    global qg

    set x [visorUltimoPixel]
    return [expr $x / $qg(anchuraDeTick) ]
}




####################
## SECCION MINIATURA
####################

proc miniaturaMovimientoEn {x y} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c .fondo.miniatura

    set x  [$c canvasx $x]
    
    set ultimoPixel [expr [lindex [$c xview] 1] * 1600]

    if { $x > 0 } {
	set tick [expr $qg(desde) + ($x / $ultimoPixel ) * $qg(duracion) ]
    } else {
	set tick $qg(desde)
    }

    $qg(etiquetaDeTick) configure -text [formatea $tick]
    set qg(etiquetaDeTickValor) $tick

}


proc miniaturaSeleccionEn {x y} {

    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }
    set c .fondo.miniatura

    set x  [$c canvasx $x]
    
    set ultimoPixel [expr [lindex [$c xview] 1] * 1600]

    if { $x > 0 } {
	set tick [expr $qg(desde) + ($x / $ultimoPixel ) * $qg(duracion) ]
    } else {
	set tick $qg(desde)
    }

    
    if { $tick > $qg(final) } {
	set $tick $qg(final)
    }

    set qg(iraltick) [format "%.$qg(posDecimales)f" $tick]
    desplazarIr
    if { $qg(panelActual) == "eventos" } {
	panelEventosRefresca
    }


}


proc miniaturaMuestraPorcion {} {

    global qg

    set c .fondo.miniatura


    set ultimoPixel [expr [lindex [$c xview] 1] * 1600]

    set desde $qg(primeroVisible)

    set hasta $qg(ultimoVisible)

    set X1 [expr ( $desde / $qg(duracion)) * $ultimoPixel]
    set X2 [expr ( $hasta / $qg(duracion)) * $ultimoPixel]
    

    $c delete all
    
    
    $c create rectangle $X1 2 $X2 30 -fill white -outline gray70

}

#############################
## SECCION GESTION DE BOTONES
#############################


proc botonesEntraEnBoton {w} {
    global qg
    set estado [$w cget -state]
    if { $estado != "disabled" } {
	$w configure -relief raised
	if {$qg(icono2De,$w) != ""} {
	    $w configure -image $qg(iconoDe,$w)
	}
    }   
}


proc botonesSaleDeBoton {w} {
    global qg

    if {$qg(icono2De,$w) == ""} {
	$w configure -text $qg(textoDe,$w) -relief flat
    } else {
	$w configure -image $qg(icono2De,$w) -relief flat
    }
}


proc botonesIniciales {} {
    global qg

    set b .botones

    $b.abrir configure    -state normal
    $b.guardar configure  -state disabled
    $b.ps configure       -state disabled
    $b.ejecutar configure -state disabled
    $b.stop configure     -state disabled
    $b.apariencia.redibujar configure -state disabled
    $b.apariencia.esquema configure   -state disabled

    set b .botonesmov

    $b.go       configure -state disabled
    $b.retpixel configure -state disabled
    $b.retpag   configure -state disabled
    $b.avpixel  configure -state disabled
    $b.avpag    configure -state disabled
    $b.retbloque  configure -state disabled
    $b.avbloque   configure -state disabled
    $b.begin      configure -state disabled
    $b.iraltick   configure -state disabled
    $b.end        configure -state disabled

    set b .visor.herramientas

    $b.paneleventos  configure -state disabled
    $b.paneldetalles configure -state disabled
    $b.arriba        configure -state disabled
    $b.abajo         configure -state disabled
    

}


proc botonesFicheroCargado {} {
    global qg

    set b .botones

    $b.abrir configure    -state normal
    $b.guardar configure  -state disabled
    $b.ps configure       -state disabled
    $b.ejecutar configure -state normal
    $b.stop configure                 -state disabled
    $b.apariencia.redibujar configure -state disabled
    $b.apariencia.esquema configure   -state disabled

    set b .botonesmov

    $b.go       configure -state disabled
    $b.retpixel configure -state disabled
    $b.retpag   configure -state disabled
    $b.avpixel  configure -state disabled
    $b.avpag    configure -state disabled
    $b.retbloque  configure -state disabled
    $b.avbloque   configure -state disabled
    $b.begin      configure -state disabled
    $b.end        configure -state disabled
    $b.iraltick   configure -state disabled

    set b .visor.herramientas

    $b.paneleventos  configure -state disabled
    $b.paneldetalles configure -state disabled
    $b.arriba        configure -state disabled
    $b.abajo         configure -state disabled

}




proc botonesTrazaPresente {} {
    global qg

    set b .botones

    $b.abrir configure    -state normal
    $b.guardar configure  -state disabled
    $b.ps configure       -state normal
    $b.ejecutar configure -state normal
    $b.stop configure     -state normal
    $b.apariencia.redibujar configure -state normal
    $b.apariencia.esquema configure   -state normal

    set b .botonesmov

    $b.go       configure -state normal
    $b.retpixel configure -state normal
    $b.retpag   configure -state normal
    $b.avpixel  configure -state normal
    $b.avpag    configure -state normal
    $b.retbloque  configure -state normal
    $b.avbloque   configure -state normal
    $b.begin      configure -state normal
    $b.end        configure -state normal
    $b.iraltick   configure -state normal

    set b .visor.herramientas

    $b.paneleventos  configure -state normal
    $b.paneldetalles configure -state normal
    $b.arriba        configure -state normal
    $b.abajo         configure -state normal
 
}



proc botonesTrazaCargada {} {
    global qg

    set b .botones

    $b.guardar configure  -state normal

}






###################
## SECCION ESQUEMAS
###################


proc esquemasCreaEsquemas {} {
    
    esquemasCreaPredefinidos

    set res [catch {glob *.kpa} paletas]
    if { $res == 0 } {
	foreach f $paletas {
	    set nombre [file tail [file rootname $f]]
	    set fd [open $f]
	    set esquema [read $fd]
	    esquemasCreaUnEsquema $nombre $esquema
	}
    }

    set res [catch {glob ~/.kiwi/*.kpa} paletas]
    if { $res == 0 } {
	foreach f $paletas {
	    set nombre [file tail [file rootname $f]]
	    set fd [open $f]
	    set esquema [read $fd]
	    esquemasCreaUnEsquema $nombre $esquema
	}
    }


}

proc esquemasCreaUnEsquema {nombre e} {
    global qg


    set qg(Esquema$nombre) $qg(EsquemaWhite)
    foreach l $e {
	set type [lindex $l 0]
	set pos [lsearch [lindex $qg(esquemasTraduccion) 0] $type]
	if { $pos == -1 } {
	    kiwiError "Sintax error in $e (-->$type)"
	}
	set type [lindex [lindex $qg(esquemasTraduccion) 1] $pos]
	set colors [lindex $l 1]
	lappend qg(Esquema$nombre) "$type [list $colors]"
    }
    if { [lsearch $qg(Esquemas) $nombre] == -1} {
	lappend qg(Esquemas) $nombre
    }
}




proc esquemasCreaPredefinidos {} {
    global qg


    set qg(EsquemaWhite) {
	
	{ejecucion { white }}
	{comienza { white }}
	{termina { white }}
	{preparada { black }}
	{plazo { white }}
	{entrasc { black }}
	{salesc { black }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
	{textoarriba { black }}
	{textoabajo { black }}

    }	

    set qg(EsquemaPink) {
	
	{ejecucion { LightPink  HotPink DeepPink }}
	{comienza { Snow4 }}
	{termina { Snow4 }}
	{preparada { Snow4 }}
	{plazo { black }}
	{entrasc { black }}
	{salesc { black }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
	{textoarriba { black }}
	{textoabajo { black }}

    }	


    set qg(EsquemaOlive) {
	
	{ejecucion {  OliveDrab1 OliveDrab2 OliveDrab3 OliveDrab}}
	{comienza { Orchid4 }}
	{termina { Orchid4  }}
	{preparada { Orchid4  }}
	{plazo { black }}
	{entrasc { black }}
	{salesc { black }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
	{textoarriba { black }}
	{textoabajo { black }}

    }	

    set qg(EsquemaCyan) {	
	{ejecucion {
	    Cyan1 Cyan2 Cyan3 Cyan4 LightCyan1 LightCyan2 LightCyan3 LightCyan4}
	}
	{comienza {
	    Cyan1 Cyan2 Cyan3 Cyan4 LightCyan1 LightCyan2 LightCyan3 LightCyan4}
	}
	{termina {
	    Cyan1 Cyan2 Cyan3 Cyan4 LightCyan1 LightCyan2 LightCyan3 LightCyan4}
	}
	{preparada { black }}
	{plazo { black }}
	{entrasc { black }}
	{salesc { black }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
	{textoarriba { black }}
	{textoabajo { black }}


    }

    set qg(EsquemaAquamarine) {	
	{ejecucion {
	    aquamarine1 aquamarine2 aquamarine3 aquamarine4}
	}
	{comienza {
	    aquamarine1 aquamarine2 aquamarine3 aquamarine4}
	}
	{termina {
	    aquamarine1 aquamarine2 aquamarine3 aquamarine4}
	}
	{preparada { black }}
	{plazo { black }}
	{entrasc { black }}
	{salesc { black }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{suspendida { black }}
	{cmodo { black }}
	{textoarriba { black }}
	{textoabajo { black }}


    }


    set qg(EsquemaRainbow) {	

	{ejecucion    { red1 orange1 yellow2 green1 blue1 #4b0082 VioletRed1 }}
	{comienza     { red3 orange3 yellow4 green3 blue3 #4b0082 VioletRed3 }}
	{termina      { red3 orange3 yellow4 green3 blue3 #4b0082 VioletRed3 }}
	{eventoarriba { red3 orange3 yellow4 green3 blue3 #4b0082 VioletRed3 }}
	{eventoabajo  { red3 orange3 yellow4 green3 blue3 #4b0082 VioletRed3 }}
	{preparada { black }}
	{plazo { black }}
	{entrasc { black }}
	{salesc { black }}
	{suspendida { black }}
	{cmodo { black }}
	{textoarriba { black }}
	{textoabajo { black }}
    }

    set qg(EsquemaGray) {	

	{ejecucion    {gray90 gray70 gray50 gray30 gray10}}
	{comienza     {white }}
	{termina      {white }}
	{eventoarriba { black }}
	{eventoabajo { black }}
	{preparada { black }}
	{plazo { black }}
	{entrasc { black }}
	{salesc { black }}
	{suspendida { black }}
	{cmodo { black }}
	{textoarriba { black }}
	{textoabajo { black }}
    }


    set qg(Esquemas) {White Cyan Aquamarine Rainbow Gray Olive Pink }

    set qg(esquemasTraduccion) { {EXEC-E READY-E START STOP DEADLINE LOCK UNLOCK PRIORITY_CHANGE ARROWUP BLOCK VLINE TEXTOVER TEXTUNDER} {ejecucion preparada comienza termina plazo entrasc salesc eventoarriba eventoabajo suspendida cmodo textoarriba textoabajo}}

}



proc esquemasCargaUnEsquema { e } {
    global  qg


    foreach elemento $e { 
	set tipo [lindex $elemento 0]
	if { [lsearch {ejecucion preparada comienza termina plazo entrasc salesc eventoarriba eventoabajo suspendida cmodo textoarriba textoabajo}  $tipo] == -1} {
	    kiwiError "ERROR: Bad color scheme:\n$elemento"
	}
	set colores [lindex $elemento 1]
	set ncolores [llength $colores]
	for {set i 0} {$i < $qg(numeroDeLineas) } {incr i} {
	    if { [info exists qg(personalizado,$tipo,$i)] } {
		set qg($tipo,$i) $qg(personalizado,$tipo,$i)
	    } else {
		set qg($tipo,$i) \
			[lindex $colores [expr $i % $ncolores]]
	    }
	}
    }
}



proc esquemasActivaEsquemaActual {} {
    global  qg 

    set existe [lsearch -exact $qg(Esquemas) $qg(esquema) ]

    if { $existe == -1 } {
	set qg(esquema) White
    }
    esquemasCargaUnEsquema $qg(Esquema$qg(esquema))

}



proc esquemasCambiaEsquemaActual {} {
    global qg

    botonesSaleDeBoton .botones.apariencia.esquema 
}




#####################
## SECCION PARAMETROS
#####################

proc parametrosPorDefecto {} {
    global qg

    set qg(anchuraDeTickInterfaz) 1
    set qg(alturaDeTickInterfaz)  12
    set qg(duracion) 200
    set qg(desde) 0
    set qg(duracion) 0
    set qg(numeroDeLineas) 4
    set qg(nombresDeLineas) {Task1 Task2 Task3 Task4}
    set qg(posDecimalesInterfaz) 9
    set qg(esquema) Olive
    set qg(primeroVisible) $qg(desde)
    set qg(primeroVisibleNuevo) $qg(desde)

}

proc parametrosDerivados {} {

    global qg ejecucionDesde preparadaDesde

    set qg(anchuraDeTick) \
	    [expr 1.0 * pow(2,$qg(anchuraDeTickInterfaz))]
    set qg(alturaDeTick)  $qg(alturaDeTickInterfaz)

    set qg(posDecimales) $qg(posDecimalesInterfaz)


    set qg(separacionEntreLineas) \
	    [expr $qg(alturaDeTick) * 3]
    set qg(numeroDeTicks) \
	    $qg(duracion)
    set qg(holguraVertical) \
	    20
    set qg(longitudDeLinea) \
	    [expr $qg(numeroDeTicks) * $qg(anchuraDeTick)]
    set qg(mediaAltura) \
	    [expr int($qg(alturaDeTick) / 2) ]
    set qg(cuartoDeAltura) \
	    [expr int($qg(alturaDeTick) / 4) ]
    set qg(mediaAnchura) \
	    [expr $qg(anchuraDeTick) / 2 ]
    if { $qg(alturaDeTick) < 30} {
	set qg(tamannoSimbolo) 4
    } else {
	set qg(tamannoSimbolo) [expr $qg(alturaDeTick) / 6]
    }
	
    set qg(cada) \
	    [dibujarCada]

    catch {font delete visorfont}
    if { $qg(alturaDeTick) <= 14 } {
	if { $qg(alturaDeTick) >= 6 } {
	    font create visorfont -family helvetica -size [expr $qg(alturaDeTick) - 2]
	} else {
	font create visorfont -family helvetica -size 4
	}	    
    } else {
	font create visorfont -family helvetica -size 12
    }    
    for {set i 0} {$i < $qg(numeroDeLineas)} {incr i} {
	set ejecucionDesde($i) -1
	set preparadaDesde($i) -1
    }

    set qg(umbral) 0

}




########################
## SECCION ABRIR FICHERO
########################


proc abrirFichero {} {
    global qg

    cargarFichero \
	    [tk_getOpenFile -title "Open Trace File"  -filetypes { {{Trace Files} {.ktr}} {{All Files} {*}} }]
}


proc cargarFichero {fichero} {
    global qg  

    if { $fichero != "" } {
	set qg(ficheroDatos) $fichero
	botonesFicheroCargado
	wm title . "Kiwi 1.0.1   [file tail $fichero]"
    }
}


#####################
##  SECCION DESPLAZAR
#####################



proc desplazarAsignaCentro {} {
    global qg
    
    set f $qg(ultimoVisible)
    set qg(centroActual) [expr $qg(primeroVisible) + ($f - $qg(primeroVisible)) / 2]

}


proc desplazarAvanzaPagina {} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c $qg(tareasVisor)
    
    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]

    if { $qg(ultimoVisible) >= [expr $qg(final) + $holgura] } {
	return
    }

    set qg(primeroVisibleNuevo) [expr $qg(primeroVisible) + $iv]

    if { [ expr $qg(primeroVisibleNuevo) + $iv ] > [expr $qg(final) + $holgura] } {
	set qg(primeroVisibleNuevo) [expr $qg(final) - $iv + $holgura]
    }

    set qg(mostrarPocoAPoco) 1
    dibujarRefresca
    desplazarAsignaCentro
    panelEventosRefresca
}


proc desplazarRetrocedePagina {} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c $qg(tareasVisor)

    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]

    if { $qg(primeroVisible) <= [expr $qg(desde) - $holgura] } {
	return
    }

    set qg(primeroVisibleNuevo) [expr $qg(primeroVisible) - [visorIntervaloVisible]]
    
    if { $qg(primeroVisibleNuevo) < [expr $qg(desde) - $holgura] } {
	set qg(primeroVisibleNuevo) [expr $qg(desde) - $holgura]
    }

    set qg(mostrarPocoAPoco) 1
    dibujarRefresca
    desplazarAsignaCentro
    panelEventosRefresca

}


proc desplazarAvanzaPixel {} {

    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c $qg(tareasVisor)

    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]

    if { $qg(ultimoVisible) >= [expr $qg(final) + $holgura] } {
	return
    }

    set tiempoPorPixel [expr (1 / $qg(anchuraDeTick)) * 2]
    set qg(primeroVisibleNuevo) [expr $qg(primeroVisible) + $tiempoPorPixel ]

    if { [ expr $qg(primeroVisibleNuevo) + $iv ] > [expr $qg(final) + $holgura] } {
	set qg(primeroVisibleNuevo) [expr $qg(final) - $iv + $holgura]
    }

    set qg(mostrarPocoAPoco) 1
    dibujarRefresca
    desplazarAsignaCentro
    panelEventosRefresca
}

proc desplazarRetrocedePixel {} {

    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }


    set c $qg(tareasVisor)

    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]

    if { $qg(primeroVisible) <= [expr $qg(desde) - $holgura] } {
	return
    }

    set tiempoPorPixel [expr (1 / $qg(anchuraDeTick)) * 2 ]
    set primeroVisibleNuevo [expr $qg(primeroVisible) - $tiempoPorPixel ]

    if { $qg(primeroVisibleNuevo) < [expr $qg(desde) - $holgura] } {
	set qg(primeroVisibleNuevo) [expr $qg(desde) - $holgura]
    }

    set qg(mostrarPocoAPoco) 1
    set qg(primeroVisibleNuevo) $primeroVisibleNuevo

    dibujarRefresca
    desplazarAsignaCentro
    panelEventosRefresca
}


proc desplazarAvanzaBloque {} {

    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c $qg(tareasVisor)

    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]

    if { $qg(ultimoVisible) >= [expr $qg(final) + $holgura] } {
	return
    }

    set qg(primeroVisibleNuevo) [expr $qg(primeroVisible) + $qg(cada) ]

    if { $qg(primeroVisibleNuevo) > [expr $qg(final) + $holgura] } {
	set qg(primeroVisibleNuevo) [expr $qg(final) + $holgura]
    }

    set qg(mostrarPocoAPoco) 1
    dibujarRefresca
    desplazarAsignaCentro
    panelEventosRefresca
}

proc desplazarRetrocedeBloque {} {

    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }


    set c $qg(tareasVisor)

    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]

    if { $qg(primeroVisible) <= [expr $qg(desde) - $holgura] } {
	return
    }

    set qg(primeroVisibleNuevo) [expr $qg(primeroVisible) - $qg(cada) ]

    if { $qg(primeroVisibleNuevo) < [expr $qg(desde) - $holgura] } {
	set qg(primeroVisibleNuevo) [expr $qg(desde) - $holgura]
    }


    set qg(mostrarPocoAPoco) 1
    dibujarRefresca
    desplazarAsignaCentro
    panelEventosRefresca
}


proc desplazarAlPrincipio {} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c $qg(tareasVisor)

    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]
    set qg(primeroVisibleNuevo) [expr $qg(desde) - $holgura]

    set qg(mostrarPocoAPoco) 1
    dibujarRefresca
    desplazarAsignaCentro    
    panelEventosRefresca
    
}

proc desplazarAlFinal {} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set c $qg(tareasVisor)
    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]
    set qg(primeroVisibleNuevo) [expr $qg(final) - [visorIntervaloVisible] + $holgura]

    set qg(mostrarPocoAPoco) 1
    dibujarRefresca
    desplazarAsignaCentro    
    panelEventosRefresca
    

}

proc desplazarIr { } {

    global qg
    
    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    if { $qg(iraltick) == "" } {
	return
    }

    set iv2 [expr [visorIntervaloVisible] / 2 ]

    set qg(centroActual) $qg(iraltick)
    set qg(primeroVisibleNuevo) [expr $qg(centroActual) - $iv2]
    
    dibujarRefresca
    panelEventosRefresca
    panelEventosBuscaDestacado $qg(iraltick)
    
}


proc desplazarIrAlTick { t } {

    global qg
    
    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set iv2 [expr [visorIntervaloVisible] / 2 ]

    set qg(centroActual) $t
    set qg(primeroVisibleNuevo) [expr $qg(centroActual) - $iv2]
    

    dibujarRefresca
    
}




#####################
## SECCION REPRODUCIR
#####################




proc reproducirErrorEnLaTraza {fd s} {
    global qg
    kiwiError "$s"
    close $fd
    interfazInfo ""
    botonesIniciales
    set qg(estado,trazacargada) 0
    set qg(estado,trazapresente) 0
    set qg(estado,dibujando) 0
    visorLimpia

}

proc reproducirTraza {} {
    global qg
    

    if { ! $qg(estado,trazacargada) &&  $qg(estado,trazapresente) } {
	return
    }

    parametrosPorDefecto
    interfazInfo "Initializing"
    botonesTrazaPresente
    set qg(estado,trazacargada) 0
    update idletasks

    set fd [open $qg(ficheroDatos)]
    
    set qg(desde) ""
    set qg(duracion) ""
    set qg(nombresDeLineas) ""
    set qg(numeroDeLineas) ""
    set yaDibujado 0
    set zoomAutomatico 1
    set qg(iraltick) ""
  
    foreach i [array names qg personalizado*] {
	unset qg($i)	
    }
    
    set max 0
    set lastTask 0
    set qg(trazaGuardada) {}
    foreach i [array names qg traza,ejec*] {
	set qg($i) ""
    }
    
    foreach i [array names qg traza,ready*] {
	set qg($i) ""
    }
    
    foreach i [array names qg traza,otros*] {
	set qg($i) ""
    }

    set qg(traza,otros) ""
    set qg(numeroDeEventos 0)
    set qg(numeroDeLineas) 30    
    set qg(trazacargada) 0

    set qg(cabecera) {}

    for {set tarea 0} {$tarea < 100} {incr tarea} {
	set qg(ejecb,$tarea) ""
	set qg(readyb,$tarea) ""
	set qg(traza,ejec,$tarea) ""
	set qg(traza,ready,$tarea) ""
	lappend qg(nombresDeLineas) "T$tarea"
    }

    set desdeCabecera ""
    set duracionCabecera ""

    # comenzamos detectando lineas de cabecera

    set i 0
    while { ! [eof $fd ]} {

	set lin [gets $fd]

	if { [llength $lin] == 0 } {
	    continue
	}
	
	if { [regexp "^#" $lin] } {
	    continue
	}
	
	set clase [lindex $lin 0]
	set arg1  [lindex $lin 1]
	set arg2  [lindex $lin 2]
	set arg3  [lindex $lin 3]
	
	switch $clase {
	    FROM {
		if { ! [validarEsTiempo $arg1] } {
		    reproducirErrorEnLaTraza "Time out of range in $lin"
		    return
		}
		set desdeCabecera $arg1
	    }
	    DURATION {
		if { ! [validarEsTiempo $arg1] } {
		    reproducirErrorEnLaTraza $fd "Time out of range in $lin"
		    return
		}
		set duracionCabecera $arg1
	    }
	    ZOOM_X {
		if { ! [validarEsNumero $arg1] } {
		    reproducirErrorEnLaTraza $fd "Invalid zoom value in $lin"
		    return
		}
		if { $arg1 < $qg(zoomXmin) || $arg1 > $qg(zoomXmax) } {
		    reproducirErrorEnLaTraza $fd "Zoom value out of range in $lin"
		    return
		}
		set qg(anchuraDeTickInterfaz) $arg1
		set qg(anchuraDeTick) \
			[expr 1.0 * pow(2,$qg(anchuraDeTickInterfaz))]
		set zoomAutomatico 0
		set umbral [visorIntervaloVisible]
	    }
	    ZOOM_Y {
		if { ! [validarEsNumero $arg1] } {
		    reproducirErrorEnLaTraza $fd "Invalid zoom value in $lin"
		    return
		}
		if { $arg1 < $qg(zoomYmin) || $arg1 > $qg(zoomYmax) } {
		    reproducirErrorEnLaTraza $fd "Zoom value out of range in $lin"
		    return
		}		
		set qg(alturaDeTickInterfaz) $arg1
	    }
	    PALETTE {
		set qg(esquema) $arg1
	    }
	    DECIMAL_DIGITS  {
		if { ! [validarEsNumero $arg1] } {
		    reproducirErrorEnLaTraza $fd "Invalid decimal digits value in $lin"
		    return
		}
		if { $arg1 < 0 || $arg1 > 9 } {
		    reproducirErrorEnLaTraza $fd "Decimal digits value out of range in $lin"
		    return
		}		
		set qg(posDecimalesInterfaz) $arg1
	    }
	    LINE_NAME {
		if { ! [validarEsNumero $arg1] } {
		    reproducirErrorEnLaTraza $fd "Invalid line value in $lin"
		    return
		}
		if { $arg1 < 0 || $arg1 > 100} {
		    reproducirErrorEnLaTraza $fd "Line value out of range in $lin"
		    return
		}
		set qg(nombresDeLineas) [lreplace $qg(nombresDeLineas) $arg1 $arg1 $arg2]
	    }
	    COLOR {

		set arg1 $qg(nombreDe,$arg1)

		if { ! [validarEsEvento $arg1] } {
		    reproducirErrorEnLaTraza $fd "Invalid event type value in $lin"
		    return
		}
		if { ! [validarEsNumero $arg2] } {
		    reproducirErrorEnLaTraza $fd "Invalid line value in $lin"
		    return
		}
		if { $arg2 < 0 || $arg2 > 100} {
		    reproducirErrorEnLaTraza $fd "Line value out of range in $lin"
		    return
		}
		
		set pos [lsearch [lindex $qg(esquemasTraduccion) 0] $arg1]
		set type [lindex [lindex $qg(esquemasTraduccion) 1] $pos]		
		set qg(personalizado,$type,$arg2) $arg3
	    }
	    default {
		break;
	    }
	}
	lappend qg(cabecera) $lin
    }


    # primer evento en la traza

    set min [lindex $lin 0]
    set qg(desde) $min
    set anterior 0

    while { ! [eof $fd ] } {

	if { [llength $lin] == 0 } {
	    set lin [gets $fd ]
	    continue
	}
	
	if { [regexp "^#" $lin] } {
	    set lin [gets $fd ]
	    continue
	}

	if { ! [validarEsEventoCorrecto $lin] } {
	    reproducirErrorEnLaTraza $fd "Invalid line $lin"
	    return
	}
	    
	set t    [lindex $lin 0]

	if { $t < $anterior } {
	    reproducirErrorEnLaTraza $fd "Line $lin out of order"
	    return
	}

	set anterior $t

	set type [lindex $lin 1]
	set linea [lindex $lin 2]

	lappend qg(trazaGuardada) $lin

	if {$t > $max } {
	    set max $t
	    set qg(final) $max
	    set qg(duracion) [expr $max -$qg(desde)]
	}	

	if {$type != "VLINE" && $type != 12} { 
	    set task [lindex $lin 2]
	    if {$task > $lastTask} {
		set lastTask $task
		set qg(numeroDeLineas) [expr $lastTask + 1]
	    }
	}

	# Primer dibujado
	if { $yaDibujado == 0 } {
	    if { $zoomAutomatico } {
		if { $i == 200 } {
		    set qg(numeroDeEventos) $i
		    reproducirPrimerDibujado $zoomAutomatico $i
		    set yaDibujado 1
		}
	    } else {
		if { $t > $umbral } {
		    set qg(numeroDeEventos) $i
		    reproducirPrimerDibujado $zoomAutomatico $i
		    set yaDibujado 1
		}
	    }
	}
	
	# Cada 200 eventos atendemos eventos

	if { $i % 200 == 0 } {
	    update
	}

	# Cada 1000 eventos acualizamos datos

	if { [expr $i + 1] % 1000 == 0 } {
	    set j [expr $i + 1]
	    interfazInfo "Processing File. Line $j"
	    visorEstableceAltura
	    set qg(numeroDeEventos) $i
	    interfazVerPrimero [formatea $qg(desde)]
	    interfazVerUltimo  [formatea $qg(final)] red
	} 

	if { $qg(hemosParado) } {
	    set qg(hemosParado) 0
	    break
	}


	switch -exact $type {
	    
	    3 {
		set tarea [lindex $lin 2]
		set qg(ejecb,$tarea) $t
	    }
	    EXEC-B {
		set tarea [lindex $lin 2]
		set qg(ejecb,$tarea) $t
	    }
	    4 {
		set tarea [lindex $lin 2]
		if {$qg(ejecb,$tarea) != ""} {
		    set color [lindex $lin 3]
		    lappend qg(traza,ejec,$tarea) "$qg(ejecb,$tarea) 100 $tarea $t $color"
		}
	    }
	    EXEC-E {
		set tarea [lindex $lin 2]
		if {$qg(ejecb,$tarea) != ""} {
		    set color [lindex $lin 3]
		    lappend qg(traza,ejec,$tarea) "$qg(ejecb,$tarea) 100 $tarea $t $color"
		}
	    }
	    5 {
		set tarea [lindex $lin 2]
		set qg(readyb,$tarea) $t
	    }
	    READY-B {
		set tarea [lindex $lin 2]
		set qg(readyb,$tarea) $t
	    }
	    6 {
		set tarea [lindex $lin 2]
		if {$qg(readyb,$tarea) != ""} {
		    set color [lindex $lin 3]
		    lappend qg(traza,ready,$tarea) "$qg(readyb,$tarea) 101 $tarea $t $color"
		}
	    }
	    READY-E {
		set tarea [lindex $lin 2]
		if {$qg(readyb,$tarea) != ""} {
		    set color [lindex $lin 3]
		    lappend qg(traza,ready,$tarea) "$qg(readyb,$tarea) 101 $tarea $t $color"
		}
	    }

	    default { 
		lappend qg(traza,otros) "$lin"
	    }
	}

	incr i
	
	set lin [gets $fd ]
    }

    close $fd

    set qg(numeroDeEventos) $i

    if { $desdeCabecera != "" } { 
	if { $desdeCabecera < $qg(desde) } {
	    set qg(desde) $desdeCabecera
	    interfazVerPrimero [formatea $qg(desde)]
	}
    }


    if { $duracionCabecera != "" } { 
	if { $duracionCabecera > $qg(duracion) } {
	    set qg(duracion) $duracionCabecera
	}
    }


    set qg(final) [expr $qg(desde) + $qg(duracion)]
    interfazVerUltimo  [formatea $qg(final)] black

    if { $qg(nombresDeLineas) == "" } {
	set qg(numeroDeLineas) [expr $lastTask + 1]
	for {set i 0} {$i < $qg(numeroDeLineas)} {incr i} {
	    lappend qg(nombresDeLineas) "Task$i"
	}
    }
 
    if { ! $yaDibujado} {
	reproducirPrimerDibujado $zoomAutomatico $qg(numeroDeEventos)
    }
    
    set qg(estado,trazacargada) 1

    botonesTrazaCargada
    interfazVerUltimo  [formatea $qg(final)] {}
    miniaturaMuestraPorcion
    interfazInfo ""
    
}


proc reproducirPrimerDibujado {zoomAutomatico i} {
    global qg

    if { $zoomAutomatico } {
	set c $qg(tareasVisor)
	    
	set pixels [expr [lindex [$c xview] 1] * 1600]	    
	    
	for {set n $qg(zoomXmin) } {$n <= $qg(zoomXmax)} {incr n} {
	    if { [expr pow(2,$n) * $qg(duracion) ] > $pixels } {
		break
	    }
	}
	    
	set qg(anchuraDeTickInterfaz) $n
    }
	
    set qg(primeroVisibleNuevo) $qg(desde)
    visorLimpia
    parametrosDerivados
    esquemasActivaEsquemaActual
	
    visorEstableceAltura
    interfazVerPrimero [formatea $qg(desde)]
    interfazVerUltimo  [formatea $qg(final)] red
    set qg(estado,trazapresente) 1
    desplazarAlPrincipio 
    update

}

###################
##  SECCION DIBUJAR
###################

proc dibujarRedibuja {} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    esquemasActivaEsquemaActual
    parametrosDerivados
    visorEstableceAltura
    panelDetallesAplicaFiltrados

    set qg(primeroVisibleNuevo) [expr $qg(centroActual) - [visorIntervaloVisible] / 2]

    set recalculaCentro 0

    set iv [visorIntervaloVisible]
    set holgura [expr $iv / $qg(holgura)]


    if { [ expr $qg(primeroVisibleNuevo) + $iv ] > [expr $qg(final) + $holgura] } {
	set qg(primeroVisibleNuevo) [expr $qg(final) - $iv + $holgura]
	set recalculaCentro 1
    }

    if { $qg(primeroVisibleNuevo) < [expr $qg(desde) - $holgura] } {
	set qg(primeroVisibleNuevo) [expr $qg(desde) - $holgura]
	set recalculaCentro 1
    }


    set qg(mostrarPocoAPoco) 1
    dibujarRefresca


    if { $recalculaCentro } {
 	desplazarAsignaCentro
    }
    panelEventosRefresca
    posicionaPanel
    interfazVerPrimero [formatea $qg(desde)]
    if { $qg(estado,trazacargada) } {
	interfazVerUltimo  [formatea $qg(final)] black
    } else {
	interfazVerUltimo  [formatea $qg(final)] red
    } 
    set ta $qg(etiquetaDeTickValor)
    $qg(etiquetaDeTick) configure -text [formatea $ta]


}


proc dibujarRefresca {} {
    global qg


    set qg(estado,dibujando) 1

    interfazInfo "Drawing"
    update idletasks

    set qg(hemosParado) 0

    visorLimpia


    set x [visorUltimoPixel]
    
    set ultimoVisible \
	    [expr $qg(primeroVisibleNuevo) + $x  / $qg(anchuraDeTick)]

    set qg(ultimoVisible) $ultimoVisible
    set qg(primeroVisibleAnterior) $qg(primeroVisible)
    set qg(primeroVisible) $qg(primeroVisibleNuevo)

    dibujarDibujaLineas

    miniaturaMuestraPorcion

    set holgura [ expr ($ultimoVisible - $qg(primeroVisible)) / 6 ]
    set izquierda [ expr $qg(primeroVisible) - $holgura ]
    set derecha   [ expr $ultimoVisible      + $holgura ]

    for {set tarea 0} {$tarea < $qg(numeroDeLineas)} {incr tarea} {

	set v $qg(primeroVisible)

	# eventos READY
	set primero 0
	set i 0

	# buscamos el mayor de los no visibles
	set prim 0
	set ult [llength $qg(traza,ready,$tarea)]
	incr ult -1

	set end 0
	while { ! $end } {
	    set med [expr $prim + ($ult - $prim) / 2]
	    if { $med == $prim } {
		set end 1
	    }
	    if { [lindex [lindex $qg(traza,ready,$tarea) $med] 0] > $v } {
		set ult $med 
	    } else {
		set prim $med
	    }
	}

	set primero $med


	if { $primero != "" } {
	    set i $primero
	    while {1} {
		set ev [lindex $qg(traza,ready,$tarea) $i]


		if { $qg(hemosParado) == 1 } {
		    break
		}
		if { $ev == "" } {
		    break
		}

		set beg [lindex $ev 0]
		if { $beg > $qg(ultimoVisible) } {
		    break
		}
		set end [lindex $ev 3]
		set color [lindex $ev 4]
		if { $beg >= $qg(primeroVisible) && $end <= $qg(ultimoVisible) } {
		    dibujarMuestraEvento $ev
		} elseif { $beg < $qg(primeroVisible) && $end > $qg(ultimoVisible) } {
		    dibujarMuestraEvento "$izquierda 101 $tarea $derecha $color"
		} elseif { $end < $qg(ultimoVisible) } {
		    dibujarMuestraEvento "$izquierda 101 $tarea $end $color"
		} else {
		    dibujarMuestraEvento "$beg 101 $tarea $derecha $color"
		}
		incr i

	    }

	}

	if { $qg(hemosParado) == 1 } {
	    break
	}

	# eventos EXEC
	set primero 0
	set i 0

	# buscamos el mayor de los no visibles

	set prim 0
	set ult [llength $qg(traza,ejec,$tarea)]
	incr ult -1

	set end 0
	while { ! $end } {
	    set med [expr $prim + ($ult - $prim) / 2]
	    if { $med == $prim } {
		set end 1
	    }
	    if { [lindex [lindex $qg(traza,ejec,$tarea) $med] 0] > $v } {
		set ult $med 
	    } else {
		set prim $med
	    }
	}

	set primero $med

	if { $primero != -1 } {
	    set i $primero
	    while {1} {
		set ev [lindex $qg(traza,ejec,$tarea) $i]
		if { $qg(hemosParado) == 1 } {
		    break
		}
		if { $ev == "" } {
		    break
		}
		set beg [lindex $ev 0]
		if { $beg > $qg(ultimoVisible) } {
		    break
		}
		set end [lindex $ev 3]
		set color [lindex $ev 4]
		if { $beg >= $qg(primeroVisible) && $end <= $qg(ultimoVisible) } {
		    dibujarMuestraEvento $ev
		} elseif { $beg < $qg(primeroVisible) && $end > $qg(ultimoVisible) } {
		    dibujarMuestraEvento "$izquierda 100 $tarea $derecha $color"
		} elseif { $end < $qg(ultimoVisible) } {
		    dibujarMuestraEvento "$izquierda 100 $tarea $end $color"
		} else {
		    dibujarMuestraEvento "$beg 100 $tarea $derecha $color"
		}
		incr i
	    }
	}

	if { $qg(hemosParado) == 1 } {
	    break
	}

    }

    set prim 0
    set ult [llength $qg(traza,otros)]
    incr ult
    
    set end 0
    while { ! $end } {
	set med [expr $prim + ($ult - $prim) / 2]
	if { $med == $prim } {
	    set end 1
	}
	if { [lindex [lindex $qg(traza,otros) $med] 0] > $v } {
	    set ult $med 
	} else {
	    set prim $med
	}
    }
    
    set i $med

    while {1} {
	set ev [lindex $qg(traza,otros) $i]
	if { $qg(hemosParado) == 1 } {
	    break
	}
	if { $ev == "" } {
	    break
	}
	set tick [lindex $ev 0]
	if { $tick <= $ultimoVisible} {
	    dibujarMuestraEvento $ev
	} else {
	    break
	}
	incr i
    }


    if { $qg(iraltick) != "" && $qg(iraltick) > $qg(primeroVisible) && $qg(iraltick) < $qg(ultimoVisible)} {
	dibujarHazPosicionIr $qg(iraltick)
    }
    

    focus .
    interfazInfo ""
    
    set qg(estado,dibujando) 0

}



proc dibujarMuestraEvento {ev} {

    global qg ejecucionDesde preparadaDesde 

    set t [lindex $ev 0]


    set tipo [lindex $ev 1]
    set linea [lindex $ev 2]


    set arg2 [lindex $ev 3]
    set arg3 [lindex $ev 4]

    switch -exact $tipo {
	100 { 
	    dibujarHazEjecucion $linea $arg2 $t $arg3  
	}
	101 { 
	   dibujarHazPreparada $linea $arg2 $t $arg3  
	}
	0 { 
	    dibujarHazComienza  $linea $t $arg2
	}
	START { 
	    dibujarHazComienza  $linea $t $arg2
	}
	1 {
	    dibujarHazTermina  $linea $t $arg2
	}
	STOP {
	    dibujarHazTermina  $linea $t $arg2
	}
	2 {
	    dibujarHazPlazo  $linea $t $arg2
	}
	DEADLINE {
	    dibujarHazPlazo  $linea $t $arg2
	}
	7 { 
	    dibujarHazEntraSC  $linea $t $arg2 $arg3  
	}
	LOCK { 
	    dibujarHazEntraSC  $linea $t $arg2 $arg3  
	}
	8 { 
	    dibujarHazSaleSC  $linea $t $arg2 $arg3 
	}
	UNLOCK { 
	    dibujarHazSaleSC  $linea $t $arg2 $arg3 
	}
	9 { 
	    dibujarHazEventoArriba  $linea $t $arg2 $arg3
	}
	PRIORITY_CHANGE { 
	    dibujarHazEventoArriba  $linea $t $arg2 $arg3
	}
	10 { 
	    dibujarHazEventoAbajo  $linea $t $arg2 $arg3  
	}
	ARROWUP { 
	    dibujarHazEventoAbajo  $linea $t $arg2 $arg3  
	}
	11 { 
	    dibujarHazSuspendida  $linea $t $arg2 $arg3  
	}
	BLOCK { 
	    dibujarHazSuspendida  $linea $t $arg2 $arg3  
	}
	12 { 
	    dibujarHazCambioDeModo  $t $linea $arg2 
	}
	VLINE { 
	    dibujarHazCambioDeModo  $t $linea $arg2 
	}
	13 { 
	    dibujarHazTextoArriba  $linea $t $arg2 $arg3
	}
	TEXTOVER { 
	    dibujarHazTextoArriba  $linea $t $arg2 $arg3
	}
	14 { 
	    dibujarHazTextoAbajo  $linea $t $arg2 $arg3  
	}
	TEXTUNDER { 
	    dibujarHazTextoAbajo  $linea $t $arg2 $arg3  
	}
	default { 
	    kiwiError "INTERNAL ERROR: in $ev"
	    exit
	}
    }
    


    ## Redibujamos de cuando en cuando
    if { $qg(mostrarPocoAPoco) } {
	incr qg(umbral)
	if { [ expr $qg(umbral) % 100 ] == 0 } {
	    update 
	}
    }

}


proc dibujarCada {} {
    global qg

    set r [expr 12 / $qg(anchuraDeTick)]

    if {$r <= 0.0000000001} {
	return 0.0000000001
    }
    if {$r <= 0.000000001} {
	return 0.000000001
    }
    if {$r <= 0.00000001} {
	return 0.00000001
    }
    if {$r <= 0.0000001} {
	return 0.0000001
    }
    if {$r <=  0.000001} {
	return 0.000001
    }
    if {$r <=  0.00001} {
	return 0.00001
    }
    if {$r <=  0.0001} {
	return 0.0001
    }
    if {$r <=  0.001} {
	return 0.001
    }
    if {$r <=  0.01} {
	return 0.01
    }
    if {$r <=  0.1} {
	return 0.1
    }
    if {$r <=  1.0} {
	return 1.0
    }
    if {$r <=  10.0} {
	return 10.0
    }
    if {$r <=  100.0} {
	return 100.0
    }
    if {$r <=  1000.0} {
	return 1000.0
    }
    if {$r <=  10000.0} {
	return 10000.0
    }



}




proc dibujarCoordenadasOrig {linea tick} {
    global  qg  

    set tick [expr $tick - $qg(primeroVisible)]

    set X1 \
	    [expr ($tick * $qg(anchuraDeTick))] 
    set Y2 \
	    [expr ( ($linea + 1) * $qg(separacionEntreLineas) ) + \
	    $qg(holguraVertical) - \
	    $qg(alturaDeTick)
	    ]
    set X2 \
	    [expr $X1 + $qg(anchuraDeTick)]
    set Y1 \
	    [expr $Y2 - $qg(alturaDeTick)]
    return [list $X1 $Y1 $X2 $Y2]
}



proc dibujarCoordenadas {linea tick} {
    global  qg  

    set tick [expr $tick - $qg(primeroVisible)]

    set X1 \
	    [expr ($tick * $qg(anchuraDeTick))] 
    set Y2 \
	    [expr ( ($linea + 1) * $qg(separacionEntreLineas) ) + \
	    $qg(holguraVertical) 
	    ]
    set X2 \
	    [expr $X1 + $qg(anchuraDeTick)]
    set Y1 \
	    [expr $Y2 - $qg(alturaDeTick)]
    return [list $X1 $Y1 $X2 $Y2]
}



proc dibujarCoordenadaY1 {linea} {
    global  qg  

    incr linea 1
    set Y1 \
	    [expr $linea * $qg(separacionEntreLineas) + $qg(holguraVertical)]
    return $Y1
}

proc dibujarCoordenadaY2 {linea} {
    global  qg  

    set Y2 \
	    [dibujarCoordenadaY1 $linea]
    incr Y2 -$qg(alturaDeTick)
    return $Y2
}



proc dibujarCoordenadaX {tick} {
    global  qg  

    set tick [expr $tick - $qg(primeroVisible)]

    set X \
	    [expr ($tick * $qg(anchuraDeTick))] 

    return $X
}





proc dibujarDibujaLineas {} {

    global qg

    set f .visor.tareasVisor
    set numeroDeLineasTemporales $qg(numeroDeLineas)
    set nombresDeLasLineas       $qg(nombresDeLineas)
    set desde        $qg(primeroVisible)
    set hasta        $qg(ultimoVisible)
    set posDecimales $qg(posDecimales)
    set cada         $qg(cada)

    if { $desde < $qg(desde) } {
	set desde $qg(desde)
    }

    if { $hasta > $qg(final) } {
	set hasta $qg(final)
    }

    set c $f.c
    set n $f.n

    # dibujamos las lineas horizontales

    for {set i 0} {$i <= $numeroDeLineasTemporales } {incr i} {
	set coords [dibujarCoordenadas $i $desde]
	set X1 [lindex $coords 0]
	set Y [lindex $coords 3]
	set coords [dibujarCoordenadas $i $hasta]
	set X2 [lindex $coords 0]

	set item [$c create line $X1 $Y $X2 $Y \
		-width 1 -fill LightYellow2 -tags "cuadricula"]
	$c lower $item cuadricula
	
	if { $i != $numeroDeLineasTemporales } {
	    $n create text \
		    78 \
		    $Y \
		    -anchor se -text [lindex $nombresDeLasLineas $i] \
		    -font standard  -tags "cuadricula"
	}
    }

    incr Y 20
    set item [$c create line $X1 $Y $X2 $Y \
	    -width 1 -fill LightYellow2  -tags "cuadricula"]
    $c lower $item cuadricula


    

    # dijamos las lineas verticales

    set cada $qg(cada)
    set grid [expr ceil ( $desde / $cada ) * $cada]

    set espaciotexto 0
    
    set coords [dibujarCoordenadas $qg(numeroDeLineas) $grid]
    set X [lindex $coords 0]
    set Y1 0 
    set Y2 [lindex $coords 3]
    set fin 0
    while {1} {
	set item [$c create line $X $Y1 $X $Y2 \
		-width 1 -fill LightYellow2 -tag cuadricula \
		]
	$c lower $item cuadricula
	if { $fin } {
	    break
	}
	set grid [expr $grid + $cada]
	if { $grid > $hasta} {
	    set fin 1
	}

	# si cabe mostramos el tiempo en la linea vertical

	set coords [dibujarCoordenadas $qg(numeroDeLineas) $grid]
	set Xpre $X
	set X [lindex $coords 0]
	set espaciotexto [expr $espaciotexto + $X - $Xpre]
	if { $espaciotexto >= 120 } {
	    set lY2 [expr $Y - 20]
	    $c create line $X $Y $X $lY2  \
		    -width 1 -fill LightYellow2 -tag cuadricula
	    set tX [expr $X - 2]
	    $c create text $tX $Y -text [formatea $grid] \
		    -anchor se -font cuadriculafont -tags "cuadricula"

	    set espaciotexto 0
	}
    }

    # mostramos el intervalo y la rejilla actual

    set qg(anchoVisible) [expr $hasta - $desde]
    set intervalo [formatea $qg(anchoVisible)]
    interfazVerAncho $intervalo
    interfazVerGrid [formatea $cada]
}




proc dibujarHazEjecucion {linea tickInicio tickFinal  color} {
    global qg

    if {! $qg(ver,EXEC) } {
	return
    }
    set X1 [dibujarCoordenadaX $tickInicio]
    set Y1 [dibujarCoordenadaY1 $linea]
    set X2 [dibujarCoordenadaX $tickFinal]
    set Y2 [expr $Y1 - $qg(alturaDeTick)]

    if {$color == ""} {
	set color $qg(ejecucion,$linea)
    }
    set item [$qg(tareasVisor) create rect $X1 $Y1 $X2 $Y2 \
	    -fill $color -outline gray30  -tags "traza"]
}



proc dibujarHazPreparada {linea tickInicio tickFinal  color} {
    global qg

    if {! $qg(ver,READY) } {
	return
    }

    set X1 [dibujarCoordenadaX $tickInicio]
    set Y [dibujarCoordenadaY1 $linea]
    set X2 [dibujarCoordenadaX $tickFinal]

    if {$color == ""} {
	set color $qg(preparada,$linea)
    }

    set item [$qg(tareasVisor) create line $X1 $Y $X2 $Y \
	    -fill $color  -tags "traza"]

}


proc dibujarHazComienza {linea tick color} {
    global qg

    if {! $qg(ver,START) } {
	return
    }

    set X [dibujarCoordenadaX $tick]
    set X1 [expr $X - $qg(tamannoSimbolo)] 
    set X2 [expr $X + $qg(tamannoSimbolo)]
 
    set Y [dibujarCoordenadaY1 $linea]
    set Y1 [expr $Y - $qg(tamannoSimbolo)]
    set Y2 [expr $Y + $qg(tamannoSimbolo)]


    if {$color == ""} {
	set color $qg(comienza,$linea)
    }
    set item [$qg(tareasVisor) create oval $X1 $Y1 $X2 $Y2 \
	    -fill $color -outline gray30 -tags "traza"]

}


proc dibujarHazTermina {linea tick color} {
    global qg

    if {! $qg(ver,STOP) } {
	return
    }

    set X1 [dibujarCoordenadaX $tick]
    set Y1 [dibujarCoordenadaY1 $linea]
    incr Y1 -$qg(alturaDeTick)

    set X2 [expr $X1 - $qg(tamannoSimbolo)]
    set Y2 [expr $Y1 - $qg(tamannoSimbolo)]
    set X3 [expr $X1 + $qg(tamannoSimbolo)]
    set Y3 $Y2

    if {$color == ""} {
	set color $qg(termina,$linea)
    }
    
    set item [$qg(tareasVisor) create polygon $X1 $Y1 $X2 $Y2 $X3 $Y3 \
	    -fill $color -outline gray30 -tags "traza"]
}


proc dibujarHazPlazo {linea tick color} {
    global qg

    if {! $qg(ver,DEADLINE) } {
	return
    }

    set X1 [dibujarCoordenadaX $tick]
    set Y [dibujarCoordenadaY1 $linea]
    set Y1 [expr $Y + $qg(tamannoSimbolo) + 1]
    set X2 [expr $X1 - $qg(tamannoSimbolo)]
    set Y2 [expr $Y1 + $qg(tamannoSimbolo)]
    set X3 [expr $X1 + $qg(tamannoSimbolo)]
    set Y3 $Y2
    
    if {$color == ""} {
	set color $qg(plazo,$linea)
    }

    $qg(tareasVisor) create polygon $X1 $Y1 $X2 $Y2 $X3 $Y3 \
	    -fill $color -outline gray30 -tags "traza"

    set X2 $X1
    set Y2 [ expr $Y -$qg(alturaDeTick) - $qg(tamannoSimbolo) * 2 ]

    set item [$qg(tareasVisor) create line $X1 $Y1 $X2 $Y2 \
	    -fill black -tags "traza"]
}




proc dibujarHazEntraSC {linea tick texto color} {
    global qg

    if {! $qg(ver,LOCK) } {
	return
    }


    set  X2 [dibujarCoordenadaX $tick]
    set  X1 $X2
    set  X1 [expr $X1 + $qg(tamannoSimbolo)]

    set Y1 [dibujarCoordenadaY1 $linea]    
    set Y2 $Y1
    incr Y2 $qg(mediaAltura)
    incr Y1 -$qg(mediaAltura)
    incr Y1 -$qg(alturaDeTick)

    if {$color == ""} {
	set color $qg(entrasc,$linea)
    }
    
    set item [$qg(tareasVisor) create line $X1 $Y1 $X2 $Y1 $X2 $Y2 $X1 $Y2  \
	    -fill $color -tags "traza"]


    if {$texto != "" && $qg(ver,ALLTEXT) } {
	set X1 [expr $X1 + 2]
	incr Y1 -2
	set item [$qg(tareasVisor) create text $X1 $Y1 \
		-font visorfont -fill black -text $texto -anchor w -tags "traza" ]
	
    }

}



proc dibujarHazSaleSC {linea tick texto color} {
    global qg

    if {! $qg(ver,UNLOCK) } {
	return
    }

    if {$color == ""} {
	set color $qg(salesc,$linea)
    }
 
    set  X2 [dibujarCoordenadaX $tick]
    set  X1 $X2
    set  X1 [expr $X1 - $qg(tamannoSimbolo)]

    set Y1 [dibujarCoordenadaY1 $linea]    
    set Y2 $Y1
    incr Y2 $qg(mediaAltura)
    incr Y1 -$qg(mediaAltura)
    incr Y1 -$qg(alturaDeTick)
   
    set item [$qg(tareasVisor) create line $X1 $Y1 $X2 $Y1 $X2 $Y2 $X1 $Y2  \
	    -fill $color -tags "traza"]


    if {$texto != "" && $qg(ver,ALLTEXT) } {
	set X1 [expr $X1 - 2]
	incr Y1 -2
	set item [$qg(tareasVisor) create text $X1 $Y1 \
		-font visorfont -fill black -text $texto -anchor e -tags "traza" ]
	
    }
}



proc dibujarHazEventoArriba {linea tick texto color} {
    global qg


    if {! $qg(ver,PRIORITY_CHANGE) } {
	return
    }
    set X [dibujarCoordenadaX $tick]
    set Y1 [dibujarCoordenadaY1 $linea]
    incr Y1 -$qg(alturaDeTick)
    set Y2 [expr $Y1 - $qg(alturaDeTick)]

    if {$color == ""} {
	set color $qg(eventoarriba,$linea)
    }
    
    set item [$qg(tareasVisor) create line $X $Y1 $X $Y2  \
	    -fill $color  -arrow first -tags "traza"]

    if { $texto != "" && $qg(ver,ALLTEXT) } {
	set X [expr $X + 6]
	set Y2 [expr $Y2 - 2]
	set item [$qg(tareasVisor) create text $X $Y2 \
		-font visorfont -fill black -text $texto -anchor nw -tags "traza" ]
	
    }

}




proc dibujarHazEventoAbajo {linea tick texto color} {
    global qg


    if {! $qg(ver,ARROWUP) } {
	return
    }

    set X [dibujarCoordenadaX $tick]
    set Y1 [dibujarCoordenadaY1 $linea]
    set Y2 [expr $Y1 + $qg(alturaDeTick) - 1]


    if {$color == ""} {
	set color $qg(eventoabajo,$linea)
    }
    
    set item [$qg(tareasVisor) create line $X $Y1 $X $Y2  \
	    -fill $color  -arrow first -tags "traza"]

    if { $texto != "" && $qg(ver,ALLTEXT) } {
	set X [expr $X + 6]
	incr Y2 2
	set item [$qg(tareasVisor) create text $X $Y2 \
		-font visorfont -fill black -text $texto -anchor sw -tags "traza"  ]
	
    }
}


proc dibujarHazTextoArriba {linea tick texto color} {
    global qg

    if {! $qg(ver,TEXTOVER) } {
	return
    }


    if { $texto != "" && $qg(ver,ALLTEXT) } {
	set X [dibujarCoordenadaX $tick]
	set Y1 [dibujarCoordenadaY1 $linea]
	incr Y1 -$qg(alturaDeTick)
	set Y2 [expr $Y1 - $qg(alturaDeTick)]


	if {$color == ""} {
	    set color $qg(eventoarriba,$linea)
	}
    
	set item [$qg(tareasVisor) create text $X $Y2 \
		-font visorfont -fill $color -text $texto -anchor nw -tags "traza" ]
	
    }

}




proc dibujarHazTextoAbajo {linea tick texto color} {
    global qg

    if {! $qg(ver,TEXTUNDER) } {
	return
    }


    if { $texto != "" && $qg(ver,ALLTEXT) } {
	set X [dibujarCoordenadaX $tick]
	set Y1 [dibujarCoordenadaY1 $linea]
	set Y2 [expr $Y1 + $qg(alturaDeTick) - 1]
	

	if {$color == ""} {
	    set color $qg(eventoabajo,$linea)
	}
    
	set item [$qg(tareasVisor) create text $X $Y2 \
		-font visorfont -fill $color -text $texto -anchor sw -tags "traza" ]
	
    }
}



proc dibujarHazPosicionIr {tick} {
    global qg

    if { $tick == ""} {
	return
    }
    $qg(tareasVisor) delete posicionir

    set linea 0

    set coords \
	    [dibujarCoordenadas $linea $tick]
    set X1 [lindex $coords 0]
    set Y1 [expr [lindex $coords 1] - $qg(mediaAltura)]
    set X2 $X1

    set linea $qg(numeroDeLineas)

    set coords \
	    [dibujarCoordenadas $linea $tick]
    set Y2 [lindex $coords 1]

    set color red
    
    set item [$qg(tareasVisor) create line $X1 $Y1 $X2 $Y2  \
	    -fill $color  -arrow both -tags "traza posicionir"]

    set texto [formatea $tick ]

    set item [$qg(tareasVisor) create text $X1 $Y1 \
	    -font pequenna \
	    -fill red -text $texto -anchor s -tags "traza posicionir" ]


    set item [$qg(tareasVisor) create text $X2 $Y2 \
	    -font pequenna \
	    -fill red -text $texto -anchor n -tags "traza posicionir" ]


}



proc dibujarHazSuspendida {linea tick texto color} {
    global qg

    if {! $qg(ver,BLOCK) } {
	return
    }

    set coords \
	    [dibujarCoordenadas $linea $tick]

    set X1 [lindex $coords 0]
    set Y1 [expr [lindex $coords 1] - $qg(cuartoDeAltura) ]
    set X2 $X1
    set Y2 [expr [lindex $coords 3] + $qg(cuartoDeAltura) ]

    if {$color == ""} {
	set color $qg(suspendida,$linea)
    }
 

    set item [$qg(tareasVisor) create line $X1 $Y1 $X2 $Y2 \
	    -fill $color -tags "traza"]


    set X3 [expr $X1 + $qg(tamannoSimbolo)]
    set X4 $X3

    set item [$qg(tareasVisor) create line $X3 $Y1 $X4 $Y2 \
	    -fill $color -tags "traza"]



    if { $texto != "" && $qg(ver,ALLTEXT) } {
	set X1 [expr $X3 + 2]
	set Y1 [expr $Y1 - 2]
	set item [$qg(tareasVisor) create text $X1 $Y1 \
		-font visorfont -fill black -text $texto -anchor w -tags "traza" ]
	
    }
}



proc dibujarHazCambioDeModo {tick texto color} {
    global qg

    if {! $qg(ver,VLINE) } {
	return
    }

    set coords \
	    [dibujarCoordenadas 0 $tick]
    set X \
	   [lindex $coords 0]
    set Y1 \
	    [expr [lindex $coords 1] - $qg(mediaAltura)]
    set coords \
	    [dibujarCoordenadas [expr $qg(numeroDeLineas)  ] $tick]
    set Y2 \
	    [expr [lindex $coords 3] ]
	   
    if {$color == ""} {
	set color $qg(cmodo,0)
    }

    set item \
	    [$qg(tareasVisor) \
	    create line $X $Y1 $X $Y2 -fill $color -width 1 -tags "traza"]

    if { $texto != "" && $qg(ver,ALLTEXT) } {
	set X [expr $X + 2]
	set item [$qg(tareasVisor) create text $X $Y2 \
		-font visorfont -fill black -text $texto -anchor sw -tags "traza" ]
	
    }

}


proc dibujarHazFlecha {ev color tag} {
    global qg

    if { $ev == "" } {
	return
    }


    set tick  [lindex $ev 0]
    set tipo  [lindex $ev 1]
    set tarea [lindex $ev 2]

    if { $tipo != "VLINE" && $tipo != 12  } {
	set tarea [lindex $ev 2]
    } else {
	set tarea $qg(numeroDeLineas)
    }

    set coords \
	    [dibujarCoordenadas $tarea $tick]
    set X \
	   [lindex $coords 0]
    set Y1 \
	    [expr [lindex $coords 3] + $qg(mediaAltura)]
    set Y2 \
	    [expr $Y1 + 20 ]

    set item \
	    [$qg(tareasVisor) \
	    create line $X $Y1 $X $Y2 -fill $color -width 5 -arrowshape "16 16 8"  -arrow first -tags "traza $tag"]

 
}

proc dibujarHazResaltado {ev} {
    global qg

    dibujarHazFlecha $ev $qg(color,resaltado) resaltado
}

proc dibujarHazDestacado {ev} {
    global qg

    dibujarHazFlecha $ev $qg(color,destacado) destacado
}



proc dibujarEliminaResaltado {} {
    global qg

    $qg(tareasVisor) delete resaltado
}

proc dibujarEliminaDestacado {} {
    global qg

    $qg(tareasVisor) delete destacado
}



proc dibujarHazSeccion {desde hasta} {
    global qg

    if {! $qg(ver,VLINE) } {
	return
    }

    set coords \
	    [dibujarCoordenadas 0 $desde]
    set X1 \
	   [lindex $coords 0]
    set Y1 0

    set coords \
	    [dibujarCoordenadas [expr $qg(numeroDeLineas)  ] $hasta]
    set X2 \
	   [lindex $coords 0]
    set Y2 \
	    [expr [lindex $coords 3] ]
	   
    set item \
	    [$qg(tareasVisor) \
	    create rectangle $X1 $Y1 $X2 $Y2 -fill $qg(color,seccion) -outline "" -tags "traza"]

    $qg(tareasVisor) lower $item cuadricula
}



#################
## SECCION MARCAS
#################



proc marcasBorrarTodas {} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    $qg(tareasVisor) delete posicionir
    set qg(iraltick) ""
    marcasBorraDrag
}




proc marcasTickDeX {x} {
    global qg
    
    set c $qg(tareasVisor)
    
    set tick \
	    [expr $qg(desde) + $x / $qg(anchuraDeTick)]
    
    if { $tick < 0 } {
	return $qg(desde)
    }
    if { $tick > [expr $qg(duracion)+$qg(desde)] } {
	return [expr $qg(numeroDeTicks) + $qg(desde)]
    }

    return $tick
}


proc marcasComienzaDrag {c x y} {
    global qg marcasValoresDrag

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }
    set x [$c canvasx $x]
    set y [$c canvasy $y]
    set marcasValoresDrag(primerTick) [marcasTickDeX $x] 

    $c delete linedrag
    $c delete textdrag
    $c create line $x $y $x $y -tag linedrag -arrow both
    $c create text $x $y \
	    -text [formatea 0 ] \
	    -tags "textdrag traza" -anchor se -fill black 
}


proc marcasDrag {c x y} {
    global qg marcasValoresDrag

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set x [$c canvasx $x]
    set y [$c canvasy $y]

    set coords [$c coords textdrag]
    set ytext [lindex $coords 1]
    $c coords textdrag $x $ytext
    set longitud [expr abs ($marcasValoresDrag(primerTick) - [marcasTickDeX $x])]
    $c itemconfigure textdrag \
	    -text [formatea $longitud ]

    set coords [$c coords linedrag]
    set x1line [lindex $coords 0]
    set y1line [lindex $coords 1]
    set y2line [lindex $coords 3]
    $c coords linedrag $x1line $y1line $x $y2line
}


proc marcasBorraDrag {} {
    set c .visor.tareasVisor.c
    $c delete linedrag
    $c delete textdrag
    $c delete dragsaved
}



proc marcasFinDrag {c} {
    global qg marcasValoresDrag

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    $c itemconfigure linedrag -tag "dragsaved traza"
    $c itemconfigure textdrag -tag "dragsaved traza"
}







##################
# SECCION IMAGENES
##################



proc iniImagenes {} {
    global qg

    set blanco #000000
    set verde1 #007d00
    set verde2 #7dff00
    set amarillo1 #ffff7d
    set amarillo2 #7d7d00
    set azulOscuro $qg(color,azulOscuro)
    set azulNormal $qg(color,azulNormal)
    set iris1 #00ffff
    set iris2 #00ff00
    set iris3 #ffff00
    set iris4 #ff0000
    set iris5 #ff00ff
    set iris6 #7d0000
    set col_00007d #00007d
    set col_0000ff #0000ff
    set col_ffffff #ffffff
    set col_9c0000 #9c0000
    set col_ff0000 #ff0000

set tablaDeImagenes {
    {
	guardar2 20 20 {
	    { $blanco -to  3  3 17  4 }
	    { $blanco -to  3  4  4 16}
	    { $blanco -to  3  4  4 16}
	    { $blanco -to  4 16 17 17}
	    { $blanco -to 16  4 17 16}
	    { $blanco -to  5  4  6 10}
	    { $blanco -to  6 10 14 11}
	    { $blanco -to 14  4 15 10}
	    { $blanco -to  6 12 15 13}
	    { $blanco -to 14 13 15 16}
	    { $blanco -to  6 13 12 16}
	    { $blanco -to 15  5}
	    { $verde1 -to  4  4  5 16}
	    { $verde1 -to  5 10  6 16}
	    { $verde1 -to  6 11 14 12}
	    { $verde1 -to 14 10 15 12}
	    { $verde1 -to 15  6 16 16}
	}
    }
    {
	guardar 20 20 {
	    { $blanco -to  3  3 17  4 }
	    { $blanco -to  3  4  4 16}
	    { $blanco -to  3  4  4 16}
	    { $blanco -to  4 16 17 17}
	    { $blanco -to 16  4 17 16}
	    { $blanco -to  5  4  6 10}
	    { $blanco -to  6 10 14 11}
	    { $blanco -to 14  4 15 10}
	    { $blanco -to  6 12 15 13}
	    { $blanco -to 14 13 15 16}
	    { $blanco -to  6 13 12 16}
	    { $blanco -to 15  5}
	    { $verde2 -to  4  4  5 16}
	    { $verde2 -to  5 10  6 16}
	    { $verde2 -to  6 11 14 12}
	    { $verde2 -to 14 10 15 12}
	    { $verde2 -to 15  6 16 16}
	}
    }


    {
	abrir2 20 20 {
	    { $blanco -to  3  6  3  7 }
	    { $blanco -to  2  7  3 16 }
 	    { $blanco -to  2 15 13 16 }
 	    { $blanco -to  7 10 18 11 }
 	    { $blanco -to 12  7 13 10 }
 	    { $blanco -to  3  7 13  8 }
 	    { $blanco -to  3  6  6  7 }
  	    { $blanco -to 15  5 17  7}
  	    { $blanco -to 12  3 14  4}
  	    { $blanco -to 11  4}
  	    { $blanco -to 14  4}
  	    { $blanco -to 14  6}
  	    { $blanco -to 16  4}
  	    { $blanco -to  6 11}
  	    { $blanco -to  5 12}
  	    { $blanco -to  4 13}
  	    { $blanco -to  3 14}
  	    { $blanco -to 16 11}
  	    { $blanco -to 15 12}
  	    { $blanco -to 14 13}
  	    { $blanco -to 13 14}
	    { $amarillo1 -to  3  7  6 12}
	    { $amarillo1 -to  6  8 12 10}
	    { $amarillo1 -to  3 12  5 13}
	    { $amarillo2 -to  3 13}
	    { $amarillo2 -to  6 10}
	    { $amarillo2 -to  7 11 16 12}
	    { $amarillo2 -to  6 12 15 13}
	    { $amarillo2 -to  5 13 14 14}
	    { $amarillo2 -to  4 14 13 15}
	}
    }
    {
	abrir 20 20 {
	    { $blanco -to  3  6  3  7 }
	    { $blanco -to  2  7  3 16 }
 	    { $blanco -to  2 15 13 16 }
 	    { $blanco -to  7 10 18 11 }
 	    { $blanco -to 12  7 13 10 }
 	    { $blanco -to  3  7 13  8 }
 	    { $blanco -to  3  6  6  7 }
  	    { $blanco -to 15  5 17  7}
  	    { $blanco -to 12  3 14  4}
  	    { $blanco -to 11  4}
  	    { $blanco -to 14  4}
  	    { $blanco -to 14  6}
  	    { $blanco -to 16  4}
  	    { $blanco -to  6 11}
  	    { $blanco -to  5 12}
  	    { $blanco -to  4 13}
  	    { $blanco -to  3 14}
  	    { $blanco -to 16 11}
  	    { $blanco -to 15 12}
  	    { $blanco -to 14 13}
  	    { $blanco -to 13 14}
	    { $amarillo1 -to  3  7  6 12}
	    { $amarillo1 -to  6  8 12 10}
	    { $amarillo1 -to  3 12  5 13}
	    { $verde1 -to  3 13}
	    { $verde1 -to  6 10}
	    { $verde1 -to  7 11 16 12}
	    { $verde1 -to  6 12 15 13}
	    { $verde1 -to  5 13 14 14}
	    { $verde1 -to  4 14 13 15}
	}
    }
    {
	stop2 18 18 {
	    { $azulOscuro -to  9  9 17 17 }
	}
    }
    {
	stop 18 18 {
	    { $azulNormal -to  9  9 17 17 }
	}
    }
    {
	go2 18 18 {
	    { $azulOscuro -to  8  10 10 8 }
	}
    }
    {
	go 18 18 {
	    { $azulNormal -to  9 9 10 17 }
	}
    }


    {
	ejecutar2 18 18 {
	    {$azulOscuro -to 12  8 12  9}
	    {$azulOscuro -to 12  9 13 10}
	    {$azulOscuro -to 12 10 14 11}
	    {$azulOscuro -to 12 11 15 12}
	    {$azulOscuro -to 12 12 16 13}
	    {$azulOscuro -to 12 13 15 14}
	    {$azulOscuro -to 12 14 14 15}
	    {$azulOscuro -to 12 15 13 16}
	    {$azulOscuro -to 12 16 12 17}
	}
    }
    {
	ejecutar 18 18 {
	    {$azulNormal -to 12  8 12  9}
	    {$azulNormal -to 12  9 13 10}
	    {$azulNormal -to 12 10 14 11}
	    {$azulNormal -to 12 11 15 12}
	    {$azulNormal -to 12 12 16 13}
	    {$azulNormal -to 12 13 15 14}
	    {$azulNormal -to 12 14 14 15}
	    {$azulNormal -to 12 15 13 16}
	    {$azulNormal -to 12 16 12 17}
	}
    }

    {
	iris 18 18 {

	    { $azulNormal -to  5  5  7  6 }
	    { $azulNormal -to  7  4 11  5 }
	    { $azulNormal -to 11  5 13  6 }
	    { $azulNormal -to  2  8}
	    { $azulNormal -to  3  7}
	    { $azulNormal -to  4  6}
	    { $azulNormal -to 13  6}
	    { $azulNormal -to 14  7}
	    { $azulNormal -to 15  8}

	    { $iris1 -to  5  6  7  7 }
	    { $iris1 -to  7  5 11  6 }
	    { $iris1 -to 11  6 13  7 }
	    { $iris1 -to  2  9}
	    { $iris1 -to  3  8}
	    { $iris1 -to  4  7}
	    { $iris1 -to 13  7}
	    { $iris1 -to 14  8}
	    { $iris1 -to 15  9}

	    { $iris2 -to  5  7  7  8 }
	    { $iris2 -to  7  6 11  7 }
	    { $iris2 -to 11  7 13  8 }
	    { $iris2 -to  2 10}
	    { $iris2 -to  3  9}
	    { $iris2 -to  4  8}
	    { $iris2 -to 13  8}
	    { $iris2 -to 14  9}
	    { $iris2 -to 15 10}

	    { $iris3 -to  5  8  7  9 }
	    { $iris3 -to  7  7 11  8 }
	    { $iris3 -to 11  8 13  9 }
	    { $iris3 -to  2 11}
	    { $iris3 -to  3 10}
	    { $iris3 -to  4  9}
	    { $iris3 -to 13  9}
	    { $iris3 -to 14 10}
	    { $iris3 -to 15 11}

            { $iris4 -to  5  9  7 10 }
	    { $iris4 -to  7  8 11  9 }
	    { $iris4 -to 11  9 13 10 }
	    { $iris4 -to  2 12}
	    { $iris4 -to  3 11}
	    { $iris4 -to  4 10}
	    { $iris4 -to 13 10}
	    { $iris4 -to 14 11}
	    { $iris4 -to 15 12}

            { $iris5 -to  5 10  7 11 }
	    { $iris5 -to  7  9 11 10 }
	    { $iris5 -to 11 10 13 11 }
	    { $iris5 -to  2 13}
	    { $iris5 -to  3 12}
	    { $iris5 -to  4 11}
	    { $iris5 -to 13 11}
	    { $iris5 -to 14 12}
	    { $iris5 -to 15 13}
	}
	
    }
    {
	iris2 18 18 {

	    { $azulNormal -to  5  5  7  6 }
	    { $azulNormal -to  7  4 11  5 }
	    { $azulNormal -to 11  5 13  6 }
	    { $azulNormal -to  2  8}
	    { $azulNormal -to  3  7}
	    { $azulNormal -to  4  6}
	    { $azulNormal -to 13  6}
	    { $azulNormal -to 14  7}
	    { $azulNormal -to 15  8}

	    { $iris1 -to  5  6  7  7 }
	    { $iris1 -to  7  5 11  6 }
	    { $iris1 -to 11  6 13  7 }
	    { $iris1 -to  2  9}
	    { $iris1 -to  3  8}
	    { $iris1 -to  4  7}
	    { $iris1 -to 13  7}
	    { $iris1 -to 14  8}
	    { $iris1 -to 15  9}

	    { $iris2 -to  5  7  7  8 }
	    { $iris2 -to  7  6 11  7 }
	    { $iris2 -to 11  7 13  8 }
	    { $iris2 -to  2 10}
	    { $iris2 -to  3  9}
	    { $iris2 -to  4  8}
	    { $iris2 -to 13  8}
	    { $iris2 -to 14  9}
	    { $iris2 -to 15 10}

	    { $amarillo2 -to  5  8  7  9 }
	    { $amarillo2 -to  7  7 11  8 }
	    { $amarillo2 -to 11  8 13  9 }
	    { $amarillo2 -to  2 11}
	    { $amarillo2 -to  3 10}
	    { $amarillo2 -to  4  9}
	    { $amarillo2 -to 13  9}
	    { $amarillo2 -to 14 10}
	    { $amarillo2 -to 15 11}

            { $iris6 -to  5  9  7 10 }
	    { $iris6 -to  7  8 11  9 }
	    { $iris6 -to 11  9 13 10 }
	    { $iris6 -to  2 12}
	    { $iris6 -to  3 11}
	    { $iris6 -to  4 10}
	    { $iris6 -to 13 10}
	    { $iris6 -to 14 11}
	    { $iris6 -to 15 12}

            { $iris5 -to  5 10  7 11 }
	    { $iris5 -to  7  9 11 10 }
	    { $iris5 -to 11 10 13 11 }
	    { $iris5 -to  2 13}
	    { $iris5 -to  3 12}
	    { $iris5 -to  4 11}
	    { $iris5 -to 13 11}
	    { $iris5 -to 14 12}
	    { $iris5 -to 15 13}
	}
	
    }
    {
	pincel 18 18 {
	    { $iris6 -to 15  3 16  5}
	    { $iris6 -to 14  4 15  6}
	    { $iris6 -to 13  5 14  7}
	    { $iris6 -to 12  6 13  8}
	    { $iris6 -to 11  7 12  9}
	    { $iris6 -to 10  8 }
	    { $iris6 -to  9  9 }
	    { $iris6 -to  8 10 }
	    { $iris6 -to  7 11 }
	    
	    { $amarillo2 -to 14  3 }
	    { $amarillo2 -to 13  4 }
	    { $amarillo2 -to 12  5 }
	    { $amarillo2 -to 11  6 }
	    { $amarillo2 -to 10  7 }
	    { $amarillo2 -to  9  8 }
	    { $amarillo2 -to  8  9 }
	    { $amarillo2 -to  7 10 }
	    { $amarillo2 -to  6 11 }
	    



	    { $blanco -to 10  9 }
	    { $blanco -to  9 10 }
	    { $blanco -to  8 11 }
	    { $blanco -to  7 12 }
	    
	    { gray60  -to  5 12 }
	    
	    { gray30  -to  6 12 }
	    { gray30  -to  7 13 }
	    { gray30  -to  6 14 }
	    { gray30  -to  5 15 }
	    
	    { $azulNormal -to  5 13 }
	    { $azulNormal -to  3 14  5 15 }
	    
	    { $iris1  -to  4 13 }
	    
	    { $azulOscuro -to  6 13 }
	    { $azulOscuro -to  5 14 }
	    { $azulOscuro -to  2 15  5 16 }
	}
    }
    {
	pincel2 18 18 {
	    { $iris6 -to 15  3 16  5}
	    { $iris6 -to 14  4 15  6}
	    { $iris6 -to 13  5 14  7}
	    { $iris6 -to 12  6 13  8}
	    { $iris6 -to 11  7 12  9}
	    { $iris6 -to 10  8 }
	    { $iris6 -to  9  9 }
	    { $iris6 -to  8 10 }
	    { $iris6 -to  7 11 }
	    
	    { $amarillo2 -to 14  3 }
	    { $amarillo2 -to 13  4 }
	    { $amarillo2 -to 12  5 }
	    { $amarillo2 -to 11  6 }
	    { $amarillo2 -to 10  7 }
	    { $amarillo2 -to  9  8 }
	    { $amarillo2 -to  8  9 }
	    { $amarillo2 -to  7 10 }
	    { $amarillo2 -to  6 11 }
	    



	    { $blanco -to 10  9 }
	    { $blanco -to  9 10 }
	    { $blanco -to  8 11 }
	    { $blanco -to  7 12 }
	    
	    { gray60  -to  5 12 }
	    
	    { gray30  -to  6 12 }
	    { gray30  -to  7 13 }
	    { gray30  -to  6 14 }
	    { gray30  -to  5 15 }
	    
	    { $azulNormal -to  5 13 }
	    { $azulNormal -to  3 14  5 15 }
	    
	    { $azulOscuro  -to  4 13 }
	    
	    { $azulOscuro -to  6 13 }
	    { $azulOscuro -to  5 14 }
	    { $azulOscuro -to  2 15  5 16 }
	}
    }

    {
	paneleventos 20 20 {
	    {$azulNormal -to  4  6  17  7}
	    {$azulNormal -to  4  8  17  9}
	    {$col_ff0000 -to  4  10 17 11}
	    {$azulNormal -to  4  12 17 13}
	    {$azulNormal -to  4  14 17 15}

	}
    }

    {
	paneldetalle 20 20 {
	    {$azulNormal -to  4  6  8  9}
	    {$qg(color,grisClaro)      -to  12  6  16  9}
	    {$qg(color,grisClaro)      -to  4  12  8  15}
	    {$azulNormal -to  12 12  16 15}
	    
	}
    }

    {
	retpixel 20 20 {
	    {$azulNormal -to  7  8  8  9}
	    {$azulNormal -to  6  9  8 10}
	    {$azulNormal -to  5 10  8 11}
	    {$azulNormal -to  4 11  8 12}
	    {$azulNormal -to  3 12  8 13}
	    {$azulNormal -to  4 13  8 14}
	    {$azulNormal -to  5 14  8 15}
	    {$azulNormal -to  6 15  8 16}
	    {$azulNormal -to  7 16  8 17}

	    {$azulNormal -to 11 12 12 13}
	    {$azulNormal -to 14 12 15 13}
	}
    }

    {
	avpixel 20 20 {
 	    {$azulNormal -to 12  8 13  9}
	    {$azulNormal -to 12  9 14 10}
	    {$azulNormal -to 12 10 15 11}
	    {$azulNormal -to 12 11 16 12}
	    {$azulNormal -to 12 12 17 13}
	    {$azulNormal -to 12 13 16 14}
	    {$azulNormal -to 12 14 15 15}
	    {$azulNormal -to 12 15 14 16}
	    {$azulNormal -to 12 16 13 17}

	    {$azulNormal -to  9 12 10 13}
 	    {$azulNormal -to  6 12  7 13}
	}
    }

    {
	retbloque 20 20 {
	    {$azulNormal -to  7  8  8  9}
	    {$azulNormal -to  6  9  8 10}
	    {$azulNormal -to  5 10  8 11}
	    {$azulNormal -to  4 11  8 12}
	    {$azulNormal -to  3 12  8 13}
	    {$azulNormal -to  4 13  8 14}
	    {$azulNormal -to  5 14  8 15}
	    {$azulNormal -to  6 15  8 16}
	    {$azulNormal -to  7 16  8 17}

	    {$azulNormal -to 10  8 11 17}
	}
    }

    {
	avbloque 20 20 {
	    {$azulNormal -to 12  8 13  9}
	    {$azulNormal -to 12  9 14 10}
	    {$azulNormal -to 12 10 15 11}
	    {$azulNormal -to 12 11 16 12}
	    {$azulNormal -to 12 12 17 13}
	    {$azulNormal -to 12 13 16 14}
	    {$azulNormal -to 12 14 15 15}
	    {$azulNormal -to 12 15 14 16}
	    {$azulNormal -to 12 16 13 17}

	    {$azulNormal -to  9  8 10 17}
	}
    }

    {
	retpag 20 20 {
	    {$azulNormal -to  7  8  8  9}
	    {$azulNormal -to  6  9  8 10}
	    {$azulNormal -to  5 10  8 11}
	    {$azulNormal -to  4 11  8 12}
	    {$azulNormal -to  3 12  8 13}
	    {$azulNormal -to  4 13  8 14}
	    {$azulNormal -to  5 14  8 15}
	    {$azulNormal -to  6 15  8 16}
	    {$azulNormal -to  7 16  8 17}

	    {$azulNormal -to  11 8 17 17}
	}
    }

    {
	avpag 20 20 {
	    {$azulNormal -to 12  8 13  9}
	    {$azulNormal -to 12  9 14 10}
	    {$azulNormal -to 12 10 15 11}
	    {$azulNormal -to 12 11 16 12}
	    {$azulNormal -to 12 12 17 13}
	    {$azulNormal -to 12 13 16 14}
	    {$azulNormal -to 12 14 15 15}
	    {$azulNormal -to 12 15 14 16}
	    {$azulNormal -to 12 16 13 17}

	    {$azulNormal -to  3  8  9 17}
	}
    }

    {
	principio 20 20 {
	    {$azulNormal -to 3  8 17  9}
	    {$azulNormal -to 3  8  4 17}
	    {$azulNormal -to 3 16 17 17}

	}
    }
    {
	final 20 20 {
	    {$azulNormal -to  3  8 17  9}
	    {$azulNormal -to 16  8 17 17}
	    {$azulNormal -to  3 16 17 17}

	}
    }
    {
	grabar 20 20 {
	    {$col_ff0000 -to  7  8 12  9}
	    {$col_ff0000 -to  6  9 13 10}
	    {$col_ff0000 -to  5 10 14 15}
	    {$col_ff0000 -to  6 15 13 16}
	    {$col_ff0000 -to  7 16 12 17}

	}
    }

    {
	borrar 20 20 {
	    {$azulNormal -to  5  8 15  9}
	    {$azulNormal -to  4  9  5 16}
	    {$col_ffffff -to  5  9 15 16}
	    {$azulNormal -to  5 16 15 17}
	    {$azulNormal -to 15  9 16 16}

	}
    }


    {
	ir 20 20 {
	    {$azulNormal -to  8  8  9  9}
	    {$azulNormal -to  7  9 10  10}
	    {$azulNormal -to  6 10 11  11}
	    {$azulNormal -to  5 11 12  12}
	    {$azulNormal -to  8 12  9  17}

	}
    }

    {
	arriba 20 20 {
	    {$azulNormal -to  8  8  9  9}
	    {$azulNormal -to  7  9 10  10}
	    {$azulNormal -to  6 10 11  11}
	    {$azulNormal -to  5 11 12  12}
	    {$azulNormal -to  8 12  9  17}

	}
    }


    {
	abajo 20 20 {

	    {$azulNormal -to  8 16  9 17}
	    {$azulNormal -to  7 15 10 16}
	    {$azulNormal -to  6 14 11 15}
	    {$azulNormal -to  5 13 12 14}
	    {$azulNormal -to  8 13  9  7}


	}
    }



    {
	paneleventos2 20 20 {
	    {$azulOscuro -to  4  6  17  7}
	    {$azulOscuro -to  4  8  17  9}
	    {$col_9c0000 -to  4  10 17 11}
	    {$azulOscuro -to  4  12 17 13}
	    {$azulOscuro -to  4  14 17 15}

	}
    }

    {
	paneldetalle2 20 20 {
	    {$azulOscuro -to  4  6  8  9}
	    {gray70      -to  12  6  16  9}
	    {gray70      -to  4  12  8  15}
	    {$azulOscuro -to  12 12  16 15}

	}
    }
    {
	avpixel2 20 20 {
 	    {$azulOscuro -to 12  8 13  9}
	    {$azulOscuro -to 12  9 14 10}
	    {$azulOscuro -to 12 10 15 11}
	    {$azulOscuro -to 12 11 16 12}
	    {$azulOscuro -to 12 12 17 13}
	    {$azulOscuro -to 12 13 16 14}
	    {$azulOscuro -to 12 14 15 15}
	    {$azulOscuro -to 12 15 14 16}
	    {$azulOscuro -to 12 16 13 17}

	    {$azulOscuro -to  9 12 10 13}
 	    {$azulOscuro -to  6 12  7 13}
	}
    }

    {
	retpixel2 20 20 {
	    {$azulOscuro -to  7  8  8  9}
	    {$azulOscuro -to  6  9  8 10}
	    {$azulOscuro -to  5 10  8 11}
	    {$azulOscuro -to  4 11  8 12}
	    {$azulOscuro -to  3 12  8 13}
	    {$azulOscuro -to  4 13  8 14}
	    {$azulOscuro -to  5 14  8 15}
	    {$azulOscuro -to  6 15  8 16}
	    {$azulOscuro -to  7 16  8 17}

	    {$azulOscuro -to 11 12 12 13}
	    {$azulOscuro -to 14 12 15 13}
	}
    }

    {
	avbloque2 20 20 {
	    {$azulOscuro -to 12  8 13  9}
	    {$azulOscuro -to 12  9 14 10}
	    {$azulOscuro -to 12 10 15 11}
	    {$azulOscuro -to 12 11 16 12}
	    {$azulOscuro -to 12 12 17 13}
	    {$azulOscuro -to 12 13 16 14}
	    {$azulOscuro -to 12 14 15 15}
	    {$azulOscuro -to 12 15 14 16}
	    {$azulOscuro -to 12 16 13 17}

	    {$azulOscuro -to  9  8 10 17}
	}
    }

    {
	retbloque2 20 20 {
	    {$azulOscuro -to  7  8  8  9}
	    {$azulOscuro -to  6  9  8 10}
	    {$azulOscuro -to  5 10  8 11}
	    {$azulOscuro -to  4 11  8 12}
	    {$azulOscuro -to  3 12  8 13}
	    {$azulOscuro -to  4 13  8 14}
	    {$azulOscuro -to  5 14  8 15}
	    {$azulOscuro -to  6 15  8 16}
	    {$azulOscuro -to  7 16  8 17}

	    {$azulOscuro -to 10  8 11 17}
	}
    }

    {
	avpag2 20 20 {
	    {$azulOscuro -to 12  8 13  9}
	    {$azulOscuro -to 12  9 14 10}
	    {$azulOscuro -to 12 10 15 11}
	    {$azulOscuro -to 12 11 16 12}
	    {$azulOscuro -to 12 12 17 13}
	    {$azulOscuro -to 12 13 16 14}
	    {$azulOscuro -to 12 14 15 15}
	    {$azulOscuro -to 12 15 14 16}
	    {$azulOscuro -to 12 16 13 17}

	    {$azulOscuro -to  3  8  9 17}
	}
    }

    {
	retpag2 20 20 {
	    {$azulOscuro -to  7  8  8  9}
	    {$azulOscuro -to  6  9  8 10}
	    {$azulOscuro -to  5 10  8 11}
	    {$azulOscuro -to  4 11  8 12}
	    {$azulOscuro -to  3 12  8 13}
	    {$azulOscuro -to  4 13  8 14}
	    {$azulOscuro -to  5 14  8 15}
	    {$azulOscuro -to  6 15  8 16}
	    {$azulOscuro -to  7 16  8 17}

	    {$azulOscuro -to  11 8 17 17}
	}
    }

    {
	principio2 20 20 {
	    {$azulOscuro -to 3  8 17  9}
	    {$azulOscuro -to 3  8  4 17}
	    {$azulOscuro -to 3 16 17 17}

	}
    }
    {
	final2 20 20 {
	    {$azulOscuro -to  3  8 17  9}
	    {$azulOscuro -to 16  8 17 17}
	    {$azulOscuro -to  3 16 17 17}

	}
    }

    {
	grabar2 20 20 {
	    {$col_9c0000 -to  7  8 12  9}
	    {$col_9c0000 -to  6  9 13 10}
	    {$col_9c0000 -to  5 10 14 15}
	    {$col_9c0000 -to  6 15 13 16}
	    {$col_9c0000 -to  7 16 12 17}

	}
    }

    {
	borrar2 20 20 {
	    {$azulOscuro -to  5  8 15  9}
	    {$azulOscuro -to  4  9  5 16}
	    {$col_ffffff -to  5  9 15 16}
	    {$azulOscuro -to  5 16 15 17}
	    {$azulOscuro -to 15  9 16 16}

	}
    }


    {
	ir2 20 20 {
	    {$azulOscuro -to  8  8  9  9}
	    {$azulOscuro -to  7  9 10  10}
	    {$azulOscuro -to  6 10 11  11}
	    {$azulOscuro -to  5 11 12  12}
	    {$azulOscuro -to  5 11 12  12}
	    {$azulOscuro -to  8 12  9  17}

	}
    }

    {
	arriba2 20 20 {
	    {$azulOscuro -to  8  8  9  9}
	    {$azulOscuro -to  7  9 10  10}
	    {$azulOscuro -to  6 10 11  11}
	    {$azulOscuro -to  5 11 12  12}
	    {$azulOscuro -to  8 12  9  17}

	}
    }


    {
	abajo2 20 20 {

	    {$azulOscuro -to  8 16  9 17}
	    {$azulOscuro -to  7 15 10 16}
	    {$azulOscuro -to  6 14 11 15}
	    {$azulOscuro -to  5 13 12 14}
	    {$azulOscuro -to  8 13  9  7}


	}
    }





}

foreach i $tablaDeImagenes {
    set nombre [lindex $i 0]
    set im \
	    [ image create photo -width [lindex $i 1] -height [lindex $i 2]]
    foreach j [lindex $i 3] { 
	eval [concat $im put $j]
    }
    set qg(imagen,$nombre)  $im
}

set qg(imagem,iris2) $qg(imagen,iris)

}


#################
# SECCION PANELES
#################



proc creaPaneles {} {
    global qg

    set qg(anchoPanelActual) 0
    set qg(panelActual) ""
    panelEventosCrea
    panelDetallesCrea

}



proc clickBotonPanel {p} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    if { $qg(panel,$p,visible) } {
	ocultaPanel $p
    } else {
	muestraPanel $p
    }

    set x [visorUltimoPixel]
    
    set $qg(ultimoVisible) \
	    [expr $qg(primeroVisibleNuevo) + $x  / $qg(anchuraDeTick)]

    desplazarAsignaCentro
    desplazarIrAlTick $qg(centroActual)
    panelEventosRefresca
}


proc muestraPanel {p} {
    global qg

    set  c $qg(tareasVisor)

    if { $qg(panelActual) != ""} {
	ocultaPanel $qg(panelActual)
    }

    set X [expr [visorUltimoPixel] - 1]
     
    set yview [$c yview]
    
    set b [lindex $yview 0]
    set e [lindex $yview 1]
    set Y [expr $b * $qg(alturaVisor)]
    
    $c coords $qg(panel,$p) $X $Y
    $c itemconfigure $qg(panel,$p) -anchor ne
    set qg(panel,$p,visible) 1
    
    set coords [$c bbox $qg(panel,$p)]
    set X1 [lindex $coords 0]
    set X2 [lindex $coords 2]

    set qg(anchoPanelActual) [expr $X2 - $X1] 
    set qg(panelActual) $p

    muestraPanel$p
}


proc ocultaPanel {p} {
    global qg

    set  c $qg(tareasVisor)

    $c coords $qg(panel,$p) -10 -10 
    $c itemconfigure $qg(panel,$p) -anchor se
    set qg(panel,$p,visible) 0

    set qg(anchoPanelActual) 0
    set qg(panelActual) ""

    ocultaPanel$p
}


proc posicionaPanel {} {

    global qg

    set p $qg(panelActual) 

    if { $p == "" } {
	return
    }
    set  c $qg(tareasVisor)
    
    set coords [$c coords $qg(panel,$p)]

    set X [lindex $coords 0]
     
    set yview [$c yview]
    
    set b [lindex $yview 0]
    set e [lindex $yview 1]
    set Y [expr $b * $qg(alturaVisor)]
    
    $c coords $qg(panel,$p) $X $Y

}

#######################
# SECCION PANEL EVENTOS
#######################



proc panelEventosIr  {i} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set v $qg(tareasVisor).panelEventos
    
    set ev $qg(panel,eventos,evento,$i)
    set t [lindex $ev 0]
    #set  qg(iraltick) ""
    desplazarIrAlTick $t
    set qg(panel,eventos,eventoDestacado) $ev
    panelEventosRefresca
}


proc panelEventosResalta {i} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set v $qg(tareasVisor).panelEventos
    
    set color $qg(color,resaltado)
    $v.tiempo$i configure -fg $color
    $v.tarea$i  configure -fg $color
    $v.desc$i   configure -fg $color
 
    set ev $qg(panel,eventos,evento,$i)
    set qg(panel,eventos,eventoResaltado) $ev
    dibujarHazResaltado $ev
}

proc panelEventosNormal {i} {
    global qg

    if { ! $qg(estado,trazapresente) || $qg(estado,dibujando) } {
	return
    }

    set v $qg(tareasVisor).panelEventos
    
    if { $qg(panel,eventos,evento,$i) == $qg(panel,eventos,eventoDestacado) } {
	$v.tiempo$i configure -fg $qg(color,destacado)
	$v.tarea$i  configure -fg $qg(color,destacado)
	$v.desc$i   configure -fg $qg(color,destacado)
    } else {
	$v.tiempo$i configure -fg black
	$v.tarea$i  configure -fg black
	$v.desc$i   configure -fg black
    }

    set qg(panel,eventos,eventoResaltado) ""
    dibujarEliminaResaltado
}    


proc panelEventosCrea {} {
    global qg


    set c $qg(tareasVisor)
    frame $c.panelEventos -bg white -relief groove -borderwidth 2 \
	    -height 100

    grid rowconfigure $c.panelEventos 0 -minsize 22
    
    for {set i 1} {$i <= 40} {incr i} {
	label $c.panelEventos.tiempo$i -font pequenna \
		-width 15 -anchor e -bg white
	bind $c.panelEventos.tiempo$i <Enter> "panelEventosResalta $i"
	bind $c.panelEventos.tiempo$i <Leave> "panelEventosNormal $i"
	bind $c.panelEventos.tiempo$i <Double-Button-1> "panelEventosIr $i"
	grid  $c.panelEventos.tiempo$i -row $i -column 1 -ipady 2 -pady 0

	label $c.panelEventos.tarea$i -font pequenna \
		-width 8 -anchor e -bg white
	bind $c.panelEventos.tarea$i <Enter> "panelEventosResalta $i"
	bind $c.panelEventos.tarea$i <Leave> "panelEventosNormal $i"
	bind $c.panelEventos.tarea$i <Double-Button-1> "panelEventosIr $i"
	grid  $c.panelEventos.tarea$i -row $i -column 2 -ipady 2 -pady 0

	label $c.panelEventos.desc$i -font pequenna \
		-width 10 -anchor w -bg white
	bind $c.panelEventos.desc$i <Enter> "panelEventosResalta $i"
	bind $c.panelEventos.desc$i <Leave> "panelEventosNormal $i"
	bind $c.panelEventos.desc$i <Double-Button-1> "panelEventosIr $i"
	grid  $c.panelEventos.desc$i -row $i -column 3 -ipady 2 -pady 0
    }


    set qg(panel,eventos) [$c create window -10 -10 -window $c.panelEventos -anchor se]
    set qg(panel,eventos,visible) 0
    set qg(panel,eventos,eventoDestacado) ""
    set qg(panel,eventos,eventoResaltado) ""

}


proc muestraPaneleventos {} {
    global qg

    set coords [grid bbox .visor.tareasVisor.c.panelEventos 0 0]
    set espacio [lindex $coords 3]

    set coords [grid bbox .visor.tareasVisor]
    set alturaPanelVisor [expr [lindex $coords 3] - $espacio]

    set coords [grid bbox .visor.tareasVisor.c.panelEventos 1 1]
    set alturaLinea [lindex $coords 3]

    set qg(panel,eventos,eventosVisibles) [expr $alturaPanelVisor / $alturaLinea - 1]
    set qg(panel,eventos,eventoDestacado) ""
    set qg(panel,eventos,eventoResaltado) ""
    set qg(holgura) 2

}

proc ocultaPaneleventos {} {
    global qg

    set qg(holgura) 8
}


proc panelEventosUnaLinea {f i j t tarea ev} {
    global qg

    if { $ev == "" } {
	$f.tiempo$j configure -text ""
	$f.tarea$j  configure -text ""
	$f.desc$j   configure -text ""
	set qg(panel,eventos,evento,$j) ""
	return
    }

    $f.tiempo$j configure -text [formatea $t]

    set tipo [lindex $ev 1]
    if { $tipo != "VLINE" && $tipo != 12  } {
	$f.tarea$j  configure -text [lindex $qg(nombresDeLineas) $tarea]
	$f.desc$j   configure -text [panelEventosDescripcion $ev]
    } else {
	$f.tarea$j  configure -text ""
	$f.desc$j   configure -text $tarea
    }


    set qg(panel,eventos,evento,$j) $ev
	    
    $f.tiempo$j configure -fg black
    $f.tarea$j  configure -fg black
    $f.desc$j   configure -fg black
}




proc panelEventosDestacado {f ev} {
    global qg

    set qg(panel,eventos,eventoDestacado) $ev
    for {set j 1} {$j < $qg(panel,eventos,eventosVisibles)} {incr j} {
	if { $qg(panel,eventos,evento,$j) == $ev } {
	    $f.tiempo$j configure -fg $qg(color,destacado)
	    $f.tarea$j  configure -fg $qg(color,destacado)
	    $f.desc$j   configure -fg $qg(color,destacado)
	}
    }
    dibujarEliminaDestacado
    dibujarHazDestacado $ev
}


proc panelEventosResaltado {f ev} {
    global qg

    set qg(panel,eventos,eventoResaltado) $ev
    for {set j 1} {$j < $qg(panel,eventos,eventosVisibles)} {incr j} {
	if { $qg(panel,eventos,evento,$j) == $ev } {
	    $f.tiempo$j configure -fg $qg(color,resaltado)
	    $f.tarea$j  configure -fg $qg(color,resaltado)
	    $f.desc$j   configure -fg $qg(color,resaltado)
	}
    }
    dibujarEliminaResaltado
    dibujarHazResaltado $ev
}


proc panelEventosBuscaDestacado {tCentral} {
    global qg

    if { $qg(panelActual) != "eventos" } {
	return
    }
 
    set f $qg(tareasVisor).panelEventos
    set ev $qg(panel,eventos,evento,1)
    set qg(panel,eventos,eventoDestacado) $ev
    set t [lindex $ev 0]
    set min [expr abs($tCentral - $t)]

    for {set j 2} {$j < $qg(panel,eventos,eventosVisibles)} {incr j} {
	set ev $qg(panel,eventos,evento,$j)
	set t [lindex $ev 0]
	set d [expr abs($tCentral - $t)]
	if { $d <= $min } {
	    set qg(panel,eventos,eventoDestacado) $ev
	    set min $d
	}
    }
    set qg(panel,eventos,eventoResaltado) ""
    dibujarEliminaResaltado
    panelEventosDestacado $f $qg(panel,eventos,eventoDestacado)
    
}

proc panelEventosRefresca {} {
    global qg

    if { $qg(panelActual) != "eventos" } {
	return
    }

    set prim 0
    set ult [llength $qg(trazaGuardada)]
    incr ult -1
    
    set v $qg(centroActual)

    # buscamos el evento central
    set end 0
    while { ! $end } {
	set med [expr $prim + ($ult - $prim) / 2]
	if { $med == $prim } {
	    set end 1
	}
	if { [lindex [lindex $qg(trazaGuardada) $med] 0] >= $v } {
	    set ult $med 
	} else {
	    set prim $med
	}
    }

    set f $qg(tareasVisor).panelEventos

    # visualizamos en el panel los eventos alrededor
    # del central


    set numEventos $qg(panel,eventos,eventosVisibles)
    set numEventosAntes [expr $numEventos / 2 - 1]
    set numEventosDespues [expr $numEventos - $numEventosAntes]

    set j $numEventosAntes
    set i $med
    set n 0
    while { ($n < $numEventosAntes) } {
	if { $i >= 0 && $i < $qg(numeroDeEventos) } {
	    set ev [lindex $qg(trazaGuardada) $i]
	    set tipo [lindex $ev 1]
	    if { [panelDetallesFiltrado $tipo] } {
		set t [lindex $ev 0]
		set tarea [lindex $ev 2]
		panelEventosUnaLinea $f $i $j $t $tarea $ev
		incr n
		incr j -1
		incr i -1
	    } else {
		incr i -1
	    }
	} else {
	    panelEventosUnaLinea $f 0 $j 0 0 ""
	    incr n
	    incr j -1
	}
    }

    set j $numEventosAntes
    incr j
    set i [expr $med + 1]
    set n 0
    while { ($n < $numEventosDespues) } {
	if { $i >= 0 && $i < $qg(numeroDeEventos) } {
	    set ev [lindex $qg(trazaGuardada) $i]
	    set tipo [lindex $ev 1]
	    if { [panelDetallesFiltrado $tipo] } {
		set t [lindex $ev 0]
		set tarea [lindex $ev 2]
		panelEventosUnaLinea $f $i $j $t $tarea $ev
		incr n
		incr j
		incr i 1
	    } else {
		incr i 1
	    }
	} else {
	    panelEventosUnaLinea $f 0 $j 0 0 ""
	    incr n
	    incr j
	}
    }

    panelEventosResaltado $f $qg(panel,eventos,eventoResaltado)
    panelEventosDestacado $f $qg(panel,eventos,eventoDestacado)

    panelEventosMuestraSeccion

    for {set j [expr $numEventos + 1]} {$j <= 40} {incr j} {
	    panelEventosUnaLinea $f 0 $j 0 0 ""
    }

}

proc panelEventosMuestraSeccion {} {
    global qg

    set visibles $qg(panel,eventos,eventosVisibles)



    set primero 1

    set i 1
    while { ($i <= $visibles) } {
	set t [lindex $qg(panel,eventos,evento,$i) 0]
	if { $t != "" && $t >= $qg(primeroVisible) } {
	    set primero $i
	    break
	}
	incr i
    }

    set ultimo $primero

    while { $i <= $visibles } {
	set t [lindex $qg(panel,eventos,evento,$i) 0]
	if { $t != "" && $t <= $qg(ultimoVisible) } {
	    set ultimo $i
	} else {
	    break
	}
	incr i
    }


    set f $qg(tareasVisor).panelEventos

    for {set i 1} {$i <= 40} {incr i} {
	if { $i >= $primero && $i <= $ultimo } {
	    $f.tiempo$i configure -bg $qg(color,seccion)
	    $f.tarea$i  configure -bg $qg(color,seccion)
	    $f.desc$i   configure -bg $qg(color,seccion)
	} else {
	    $f.tiempo$i configure -bg white
	    $f.tarea$i  configure -bg white
	    $f.desc$i   configure -bg white
	}	    
    }

    set desde ""
    set i $primero
    while { ($i <= $visibles)} {
	set t [lindex $qg(panel,eventos,evento,$i) 0]
	if { $t != "" } {
	    set desde $t
	    break
	}
	incr i
    }

    while { $i <= $ultimo } {
	set t [lindex $qg(panel,eventos,evento,$i) 0]
	if { $t != "" } {
	    set hasta $t
	} else {
	    break
	}
	incr i
    }


    dibujarHazSeccion $desde $hasta




}



proc panelEventosDescripcion {ev} {

    set tipo [lindex $ev 1]
    set arg2 [lindex $ev 3]

    switch -exact $tipo {
	0 { 
	    return "start"
	}
	START { 
	    return "start"
	}
	1 {
	    return "stop"
	}
	STOP {
	    return "stop"
	}
	2 {
	    return "has deadline"
	}
	DEADLINE {
	    return "has deadline"
	}
	3 {
	    return "gets cpu"
	}
	EXEC-B {
	    return "gets cpu"
	}
	4 {
	    return "leaves cpu"
	}
	EXEC-E {
	    return "leaves cpu"
	}
	5 {
	    return "gets ready"
	}
	READY-B {
	    return "gets ready"
	}
	6 {
	    return "gets unready"
	}
	READY-E {
	    return "gets unready"
	}	
	7 { 
	    return "locks $arg2"
	}
	LOCK { 
	    return "locks $arg2"
	}
	8 { 
	    return "unlocks $arg2"
	}
	UNLOCK { 
	    return "unlocks $arg2"
	}
	9 { 
	    return " $arg2"
	}
	PRIORITY_CHANGE { 
	    return " $arg2"
	}
	10 { 
	    return " $arg2"
	}
	ARROWUP { 
	    return " $arg2"
	}
	11 { 
	    return " blocks in $arg2"
	}
	BLOCK { 
	    return " blocks in $arg2"
	}
	12 { 
	}
	VLINE { 
	}
	13 { 
	    return " $arg2"
	}
	TEXTOVER { 
	    return " $arg2"
	}
	14 { 
	    return " $arg2"
	}
	TEXTUNDER { 
	    return " $arg2"
	}
	default { 
	}
    }
    
    return ""
   
}


########################
# SECCION PANEL DETALLES
########################

proc panelDetallesFiltrado {tipo} {
    global qg

    switch -exact $tipo {
	    
	0 {  return $qg(ver,START)
	}
	START { return $qg(ver,START) 
	}
	1 { return $qg(ver,STOP)
	}
	STOP { return $qg(ver,STOP)
	}
	2 { return $qg(ver,DEADLINE)
	}
	DEADLINE { return $qg(ver,DEADLINE)
	}	  
	3 { return $qg(ver,EXEC)
	}
	EXEC-B { return $qg(ver,EXEC)
	}
	4 { return $qg(ver,EXEC)
	}
	EXEC-E { return $qg(ver,EXEC)
	}
	5 { return $qg(ver,READY)
	}
	READY-B { return $qg(ver,READY)
	}
	6 { return $qg(ver,READY)
	}
	READY-E { return $qg(ver,READY)
	}
	7 {  return $qg(ver,LOCK)
	}
	LOCK {  return $qg(ver,LOCK)
	}
	8 {  return $qg(ver,UNLOCK)
	}
	UNLOCK {  return $qg(ver,UNLOCK)
	}
	9 {  return $qg(ver,PRIORITY_CHANGE)
	}
	PRIORITY_CHANGE {  return $qg(ver,PRIORITY_CHANGE)
	}
	10 {  return $qg(ver,ARROWUP)
	}
	ARROWUP {  return $qg(ver,ARROWUP)
	}
	11 {  return $qg(ver,BLOCK)
	}
	BLOCK {  return $qg(ver,BLOCK)
	}
	12 {  return $qg(ver,VLINE)
	}
	VLINE {  return $qg(ver,VLINE)
	}
	13 {  return $qg(ver,TEXTOVER)
	}
	TEXTOVER {  return [expr $qg(ver,TEXTOVER) && $qg(ver,ALLTEXT)]
	}
	14 {  return ($qg(ver,TEXTUNDER)
	}
	TEXTUNDER {  return [expr $qg(ver,TEXTUNDER) && $qg(ver,ALLTEXT)]
	}
	default { 
	    kiwiError "INTERNAL ERROR: in $ev"
	}	
    }
    
}
    



proc panelDetallesBase {c X Y alto ancho tag} {
    global qg

    set X1 [expr $X + 1]
    set Y1 [expr $Y + 1]
    set X2 [expr $X1 + $ancho - 2]
    set Y2 [expr $Y1 + $alto  - 2]

    set qg(detalle,$tag) [$c create rectangle $X1 $Y1 $X2 $Y2 -fill white -outline white -tags "$tag-marco"]
 
    $c bind $tag <Enter> "panelElementosEntraEnElemento $c $tag"
    $c bind $tag <Leave> "panelElementosSaleDeElemento  $c $tag"
    $c bind $tag-marco <Enter> "panelElementosEntraEnElemento $c $tag"
    $c bind $tag-marco <Leave> "panelElementosSaleDeElemento  $c $tag"
    $c bind $tag <Button-1> "panelElementosClickEnElemento $c $tag"
    $c bind $tag-marco <Button-1> "panelElementosClickEnElemento $c $tag"
   
}

proc panelElementosClickEnElemento {c tipo} {
    global qg

    set qg(verInterfaz,$tipo) [expr ! $qg(verInterfaz,$tipo)]
    if { $qg(verInterfaz,$tipo) } {
	$c itemconfigure $tipo -fill $qg(color,azulOscuro)
	catch {$c itemconfigure $tipo -outline black}
    } else {
	$c itemconfigure $tipo -fill gray80
	catch {$c itemconfigure $tipo -outline gray80}
    }
}

proc panelElementosEntraEnElemento {c tipo} {
    global qg

    $c itemconfigure $tipo-marco -outline $qg(color,azulOscuro)
}

proc panelElementosSaleDeElemento {c tipo} {
     global qg
   
    $c itemconfigure $tipo-marco -outline white
}



proc panelDetallesCrea {} {
    global qg


    set f [frame $qg(tareasVisor).panelDetalles -bg white -relief groove -borderwidth 2]

    set c [canvas $f.c -width 66 -height 200 -bg white -highlightthickness 0]
    grid $f.c -row 0

    set ancho 32
    set alto  24

    set X 2
    set Y 2


    set tag "EXEC"
    set anchoElem 20
    set altoElem  12
    set X1 [expr $X + ($ancho - $anchoElem) / 2]
    set Y1 [expr $Y + ($alto - $altoElem) / 2]
    set X2 [expr $X1 + $anchoElem]
    set Y2 [expr $Y1 + $altoElem]

    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create rectangle $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -outline black -tag $tag

    incr X $ancho

    set tag "READY"
    set anchoElem 20
    set X1 [expr $X + ($ancho - $anchoElem) / 2]
    set Y1 [expr $Y + $alto / 2]
    set X2 [expr $X1 + $anchoElem]
    set Y2 $Y1

    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create line $X1 $Y1 $X2 $Y2  \
	    -fill $qg(color,azulOscuro) -tag $tag

    incr X [expr -$ancho]
    incr Y $alto

    set tag "START"
    set altoElem  8
    set anchoElem 8
    set X1 [expr $X + ($ancho - $anchoElem) / 2]
    set Y1 [expr $Y + ($alto - $altoElem) / 2]
    set X2 [expr $X1 + $anchoElem ]
    set Y2 [expr $Y1 + $anchoElem ]
    
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create oval $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -outline black -tag $tag

    incr X $ancho

    set tag "STOP"
    set anchoElem 6
    set altoElem  6
    set X1 [expr $X + ($ancho / 2)]
    set Y1 [expr $Y + $alto / 2 + $altoElem / 2]
    set X2 [expr $X1 + $anchoElem / 2]
    set Y2 [expr $Y1 - $altoElem]
    set X3 [expr $X1 - $anchoElem / 2]
    set Y3 [expr $Y1 - $altoElem]
    
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create polygon $X1 $Y1 $X2 $Y2 $X3 $Y3 \
	    -fill $qg(color,azulOscuro) -outline black -tag $tag

    incr X [expr -$ancho]
    incr Y $alto

    set tag "LOCK"
    set anchoElem 6
    set altoElem  16
    set X2 [expr $X + ($ancho - $anchoElem) / 2]
    set Y2 [expr $Y + ($alto - $altoElem) / 2]
    set X1 [expr $X2 + $anchoElem]
    set Y1 $Y2
    set X3 $X2
    set Y3 [expr $Y1 + $altoElem]
    set X4 $X1
    set Y4 $Y3
    
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create line $X1 $Y1 $X2 $Y2 $X3 $Y3 $X4 $Y4 \
	    -fill $qg(color,azulOscuro) -tag $tag

    incr X $ancho

    set tag "UNLOCK"
    set anchoElem 6
    set altoElem  16
    set X1 [expr $X + ($ancho - $anchoElem) / 2]
    set Y1 [expr $Y + ($alto - $altoElem) / 2]
    set X2 [expr $X1 + $anchoElem]
    set Y2 $Y2
    set X3 $X2
    set Y3 [expr $Y1 + $altoElem]
    set X4 $X1
    set Y4 $Y3
    
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create line $X1 $Y1 $X2 $Y2 $X3 $Y3 $X4 $Y4 \
	    -fill $qg(color,azulOscuro) -tag $tag


    incr X [expr -$ancho]
    incr Y $alto


    set tag "BLOCK"
    set anchoElem 3
    set altoElem  16
    set X1 [expr $X + ($ancho - $anchoElem) / 2]
    set Y1 [expr $Y + ($alto - $altoElem) / 2]
    set X2 $X1
    set Y2 [expr $Y1 + $altoElem]
    
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create line $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -tag $tag

    set X1 [expr $X1 + $anchoElem]
    set X2 $X1
    $c create line $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -tag $tag


    incr X $ancho

    set tag "DEADLINE"
    set anchoElem 8
    set altoElem  16
    set X1 [expr $X + ($ancho / 2)]
    set Y1 [expr $Y + $alto / 2]
    set X2 [expr $X1 + $anchoElem / 2]
    set Y2 [expr $Y1 + $anchoElem - 2]
    set X3 [expr $X1 - $anchoElem / 2]
    set Y3 $Y2 

    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create polygon $X1 $Y1 $X2 $Y2 $X3 $Y3 \
	    -fill $qg(color,azulOscuro) -outline black -tag $tag

    set Y1 [expr $Y + ($alto - $altoElem) / 2]

    $c create line $X1 $Y1 $X1 $Y2 \
	    -fill $qg(color,azulOscuro) -tag $tag



    incr X [expr -$ancho]
    incr Y $alto


    set tag "ARROWUP"
    set anchoElem 1
    set altoElem  12
    set X1 [expr $X + ($ancho - $anchoElem) / 2]
    set Y1 [expr $Y + ($alto - $altoElem) / 2]
    set X2 $X1
    set Y2 [expr $Y1 + $altoElem]
    
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create line $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -arrow first -tag $tag

    incr X $ancho

    set tag "PRIORITY_CHANGE"
    set anchoElem 1
    set altoElem  12
    set X1 [expr $X + ($ancho - $anchoElem) / 2]
    set Y1 [expr $Y + ($alto - $altoElem) / 2]
    set X2 $X1
    set Y2 [expr $Y1 + $altoElem]
    
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create line $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -arrow last -tag $tag



    incr X [expr -$ancho]
    incr Y $alto

    set tag "TEXTOVER"
    set anchoElem 16
    set X1 [expr $X + ($ancho / 2)]
    set Y1 [expr $Y + ($alto  / 2)]
    incr Y1 2

    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create text $X1 $Y1\
	    -fill $qg(color,azulOscuro) -text "a b c" -font pequenna -anchor s -tag $tag

    set X1 [expr $X1 - ($anchoElem / 2)]
    set X2 [expr $X1 + $anchoElem]
    set Y1 [expr $Y1 + 2]
    set Y2 $Y1

    $c create line $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -tag $tag


    incr X $ancho

    set tag "TEXTUNDER"
    set anchoElem 16
    set X1 [expr $X + ($ancho / 2)]
    set Y1 [expr $Y + ($alto  / 2)]
    incr Y1 -2

    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create text $X1 $Y1\
	    -fill $qg(color,azulOscuro) -text "a b c" -font pequenna -anchor n -tag $tag

    set X1 [expr $X1 - ($anchoElem / 2)]
    set X2 [expr $X1 + $anchoElem]
    set Y1 [expr $Y1 - 2]
    set Y2 $Y1

    $c create line $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -tag $tag



    incr X [expr -$ancho]
    incr Y $alto

    set tag "ALLTEXT"
    set X1 [expr $X + ($ancho / 2)]
    set Y1 [expr $Y + ($alto  / 2)]

    set texto "all
text"
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create text $X1 $Y1\
	    -fill $qg(color,azulOscuro) -text $texto \
	    -justify center -font pequenna -anchor center -tag $tag



    incr X $ancho

    set tag "VLINE"
    set anchoElem 1
    set altoElem  16
    set X1 [expr $X + ($ancho - $anchoElem) / 2]
    set Y1 [expr $Y + ($alto - $altoElem) / 2]
    set X2 $X1
    set Y2 [expr $Y1 + $altoElem]
    
    panelDetallesBase $c $X $Y $alto $ancho $tag
    $c create line $X1 $Y1 $X2 $Y2 \
	    -fill $qg(color,azulOscuro) -tag $tag




    set qg(panel,detalles) [$qg(tareasVisor) create window -10 -10 -window $f -anchor se]
    set qg(panel,detalles,visible) 0

    foreach tipo $qg(eventosPorNombre) {
	set qg(verInterfaz,$tipo) 1
	set qg(ver,$tipo) 1
    }

    label $f.mdecimales -bg white -font pequenna

    scale $f.sdecimales -from 0 -to 9 \
	    -orient horizontal \
	    -showvalue no \
	    -width 6 \
	    -borderwidth 1 \
	    -bg white -activebackground $qg(color,azulOscuro) \
	    -highlightthickness 0 -troughcolor $qg(color,grisClaro) \
	    -variable qg(posDecimalesInterfaz) \
	    -command "panelDetallesNuevosDecimales $f.mdecimales"\
	    -showvalue Yes \
	    -font pequenna

    grid $f.sdecimales -row 1 -column 0 -padx 3 -pady 3
    grid $f.mdecimales -row 2 -column 0 -padx 3 -pady 3

    canvas $f.fondo -width 10 -height 1000 -bg white -highlightthickness 0
    grid $f.fondo -row 9
}

proc panelDetallesAplicaFiltrados {} {
    global qg

    foreach tipo $qg(eventosPorNombre) {
	set qg(ver,$tipo) $qg(verInterfaz,$tipo)
    }

}

proc  panelDetallesNuevosDecimales {l v} {
    global qg
    $l configure -text [formatea 0.0 $qg(posDecimalesInterfaz)]
    
}

proc muestraPaneldetalles {} {

}

proc ocultaPaneldetalles {} {

}


###############################################
# SECCION COMENZAMOS
###############################################


set tcl_precision 17

if { $argc == 0 } {
    interfazCrea
} elseif { $argc == 1 } {
    if {  [lindex $argv 0] == "--colors" } {
	tk_chooseColor -title "RGB Colors"
	exit
    }
    interfazCrea
    cargarFichero [lindex $argv 0]
} else {
    puts {usage kiwi [ file | --colors ] }
    exit
}
