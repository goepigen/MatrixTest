animateMatrices := proc(m::Matrix, {colors::list := [red]})
    local finalTime, times, animationData, qubitAnim:

    finalTime := LinearAlgebra:-Dimensions(m)[1];
    times := [seq(1 .. finalTime, 1)];

    # https://www.mapleprimes.com/questions/132306-How-To-Pass-Optional-Arguments-With-Repeated-Name
    animationData := computeArrowsAndSphereAnimationData(m, _rest, ':-colors'=colors):

    qubitAnim := displayAnimationData(animationData):

    return qubitAnim:
end:

# Pass in variable number of matrices (at least one) and a named parameter colors with the corresponding list of colors to use
# for the arrows
computeArrowsAndSphereAnimationData := proc(m::Matrix, {colors::list := [red]})
    local windowSize, finalTime, times, nMatrices, nColors, i, animColors, sphereDisplay, arrowDisplay:

    # _nrest is the number of extra arguments besides the ones listed in the parameters list
    nMatrices := 1 + _nrest;

    nColors := numelems(colors):

    animColors := colors:

    if (nColors < nMatrices) then 
        animColors := [op(animColors), op(getRandomColor(nMatrices-nColors))]:
    end:

    finalTime := LinearAlgebra:-Dimensions(m)[1];
    times := [seq(1 .. finalTime, 1)];

    windowSize := 1000;

    arrowDisplay := computeArrowAnimationData(m, animColors[1]), 
        seq(computeArrowAnimationData(_rest[i], animColors[i+1]), i=1.._nrest);

    sphereDisplay := plottools:-sphere([0, 0, 0], 1, transparency = 0.9);

    return [sphereDisplay, arrowDisplay]
end:

computeArrowAnimationData := proc(m::Matrix, color := red)
    local finalTime, times, windowSize, t, arrowAndTrailDisplay:

    finalTime := LinearAlgebra:-Dimensions(m)[1];
    times := [seq(1 .. finalTime, 1)];
    windowSize := 1000;

    arrowAndTrailDisplay := plots:-display(seq(plots:-display(
        computeArrowPlotData(m, t, color),
        computeTrailPlotData(m, t, windowSize, color)), 
        t=times), insequence=true):

    return arrowAndTrailDisplay;
end:

computeArrowPlotData := proc(m::Matrix, t, arrowColor) return plots:-pointplot3d(m[t], color = arrowColor); end:

computeTrailPlotData := proc(m::Matrix, t, windowSize, trailColor) 
    # for the number of points less than or equal to windowSize, the window size equals the number of points
    if t <= windowSize then 
        return plots:-pointplot3d(m[1 .. t, () .. ()], connect = true, color = trailColor); 
    end if; 
    
    # after the windowSize-th point, the window size is fixed at windowSize
    return plots:-pointplot3d(m[t - windowSize + 1 .. t, () .. ()], connect = true, color=trailColor); 
end:

displayAnimationData := proc(animationData::list)
    local anim:

    anim := plots:-display
        (seq(animationData), 
        scaling = constrained, 
        axes = boxed):
    
    return anim;
end: