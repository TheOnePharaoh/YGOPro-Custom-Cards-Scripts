--Aetherian's Renforcements
function c59821163.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c59821163.condition)
	e1:SetTarget(c59821163.target)
	e1:SetOperation(c59821163.activate)
	c:RegisterEffect(e1)
	--pendulum summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c59821163.operation)
	c:RegisterEffect(e2)
end
function c59821163.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not tc1 or not tc2 or not tc1:IsSetCard(0xa1a2) or not tc2:IsSetCard(0xa1a2) then return false end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	return scl1==2 and scl2==5
end
function c59821163.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c59821163.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c59821163.operation(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821163,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,59821163)
	e1:SetCondition(c59821163.pencon)
	e1:SetOperation(c59821163.penop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1,tp)
end
function c59821163.penfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden() and c:IsSetCard(0xa1a2)
end
function c59821163.pencon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if lpz==nil or rpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c59821163.penfilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c59821163.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c59821163.penop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=nil
	if og then
		tg=og:Filter(tp,c59821163.penfilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(c59821163.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,lscale,rscale)
	end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and (ect<=0 or ect>ft) then ect=nil end
	if ect==nil or tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,1,ft,nil)
		sg:Merge(g)
	else
		repeat
			local ct=math.min(ft,ect)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg:Select(tp,1,ct,nil)
			tg:Sub(g)
			sg:Merge(g)
			ft=ft-g:GetCount()
			ect=ect-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		until ft==0 or ect==0 or not Duel.SelectYesNo(tp,210)
		local hg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		if ft>0 and ect==0 and hg:GetCount()>0 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=hg:Select(tp,1,ft,nil)
			sg:Merge(g)
		end
	end
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
end
