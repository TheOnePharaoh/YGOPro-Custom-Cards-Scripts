--Lei Kun, Thunder God of the Sky Nirvana
function c44559817.initial_effect(c)
	c:SetUniqueOnField(1,0,44559817)
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c44559817.fuscon)
	e1:SetOperation(c44559817.fusop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44559817,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c44559817.condition)
	e3:SetTarget(c44559817.target)
	e3:SetOperation(c44559817.operation)
	c:RegisterEffect(e3)
  --Indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c44559817.efilter)
	c:RegisterEffect(e4)
end
function c44559817.ffilter1(c)
	return (c:IsFusionSetCard(0x2016) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c44559817.ffilter2(c)
	if c:IsHasEffect(6205579) then return false end
	return c:IsHasEffect(511002961) or c:IsRace(RACE_DRAGON) or c:IsHasEffect(44559838)
end
function c44559817.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not g:IsContains(c)
end
function c44559817.check1(c,mg,sg,chkf,tp)
	local g=mg:Clone()
	if sg:IsContains(c) then g:Sub(sg) end
	return g:IsExists(c44559817.check2,1,c,c,chkf,tp)
end
function c44559817.check2(c,c2,chkf,tp)
	local g=Group.FromCards(c,c2)
	if g:IsExists(aux.TuneMagFusFilter,1,nil,g,tp) then return false end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=g:GetFirst()
	while tc do
		if c44559817.ffilter1(tc) or tc:IsHasEffect(511002961) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if c44559817.ffilter2(tc) or tc:IsHasEffect(511002961) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=g:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2c,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2c,1,nil,g2) end
end
function c44559817.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local chkf=bit.band(chkf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc and fc:IsHasEffect(44559840) and fc:IsCanRemoveCounter(tp,0x1117,3,REASON_EFFECT) then
		sg=Duel.GetMatchingGroup(c44559817.exfilter,tp,0,LOCATION_MZONE,nil,g)
		mg:Merge(sg)
	end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return c44559817.check1(gc,mg,sg,chkf)
	end
	return mg:IsExists(c44559817.check1,1,nil,mg,sg,chkf)
end
function c44559817.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local c=e:GetHandler()
	local exg=Group.CreateGroup()
	local mg=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local p=tp
	local sfhchk=false
	if fc and fc:IsHasEffect(44559840) and fc:IsCanRemoveCounter(tp,0x1117,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c44559817.exfilter,tp,0,LOCATION_MZONE,nil,eg)
		exg:Merge(sg)
		mg:Merge(sg)
	end
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	if gc then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local g1=mg:FilterSelect(p,c44559817.check2,1,1,gc,gc,chkf)
		local tc1=g1:GetFirst()
		if c44559817.exfilter(tc1,eg) then
			fc:RemoveCounter(tp,0x1117,3,REASON_EFFECT)
		end
		if sfhchk then Duel.ShuffleHand(tp) end
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g1=mg:FilterSelect(p,c44559817.check1,1,1,nil,mg,exg,chkf)
	local tc1=g1:GetFirst()
	if c44559817.exfilter(tc1,eg) then
		fc:RemoveCounter(tp,0x1117,3,REASON_EFFECT)
		mg:Sub(exg)
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(p,c44559817.check2,1,1,tc1,tc1,chkf)
	if c44559817.exfilter(g2:GetFirst(),eg) then fc:RemoveCounter(tp,0x1117,3,REASON_EFFECT) end
	g1:Merge(g2)
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(g1)
end
function c44559817.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c44559817.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c44559817.cfilter,1,nil,tp)
end
function c44559817.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c44559817.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=tg:Select(1-tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c44559817.efilter(e,re,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end