function h = eq_axes(h_fig, varargin)
% EQ_AXES(H_FIG) equalizes the axes ranges in a given figure
%
% H_FIG  handle to the figure
% OPTIONAL:
% DIM dimension for which the equalization shall be done
%     [0: all], 1: x, 2: y, 3: z
% MAKE_SYMM  make symmetrical [true]
%

  optargs = {0, true};

  numvarargs = length(varargin);
  if numvarargs
    optargs(1:numvarargs) = varargin;
  end
  [dim, make_symm] = optargs{:};

  % select dimension
  all_dims = ['X', 'Y', 'Z'];
  if dim == 0
    use_dims = all_dims;
  else
    use_dims = [all_dims(dim)];
  end

  %h_fig = f_handles(1);
  h_axes = findall(h_fig, 'type', 'axes');

  for iDim = use_dims
    [rmin, rmax] = get_range(iDim);
    if make_symm && (sign(rmin) ~= sign(rmax))
      % symmetry only makes sense when over axes
      rval = max(abs([rmin, rmax]));
      vmin = sign(rmin) * rval;
      vmax = sign(rmax) * rval;
    else
      vmin = rmin;
      vmax = rmax;
    end

    for h_ax = h_axes
      set(h_ax, [iDim, 'Lim'], [vmin, vmax]);
    end
  end

  function [range_min, range_max] = get_range(dim)
    lims = get(h_axes, [dim, 'Lim']);
    if iscell(lims)
      lims = cell2mat(lims);
    end
    range_min = min(lims(:, 1));
    range_max = max(lims(:, 2));
  end
end
