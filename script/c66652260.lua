--Shadow Vocaloid Yamatouchi Iori
function c66652260.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c66652260.fscon)
	e1:SetOperation(c66652260.fsop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c66652260.splimit)
	c:RegisterEffect(e2)
	--attack limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c66652260.atkcon)
	e3:SetTarget(c66652260.atktg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c66652260.checkop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--negate spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66652260,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c66652260.negcon)
	e5:SetCost(c66652260.negcost)
	e5:SetTarget(c66652260.negtg)
	e5:SetOperation(c66652260.negop)
	c:RegisterEffect(e5)
end
function c66652260.filter1(c)
	return c:IsSetCard(0x0dac405)
end
function c66652260.filter2(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c66652260.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=c66652260.filter1
	local f2=c66652260.filter2
	local chkf=bit.band(chkfnf,0xff)
	local tp=e:GetHandlerPlayer()
	local fg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,77693536)
	local fc=fg:GetFirst()
	while fc do
		g:Merge(fc:GetEquipGroup():Filter(Card.IsControler,nil,tp))
		fc=fg:GetNext()
	end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
		return (f1(gc) and mg:IsExists(f2,1,gc))
			or (f2(gc) and mg:IsExists(f1,1,gc)) end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=mg:GetFirst()
	while tc do
		if f1(tc) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if f2(tc) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2,1,nil,g2) end
end
function c66652260.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=c66652260.filter1
	local f2=c66652260.filter2
	local chkf=bit.band(chkfnf,0xff)
	local fg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,77693536)
	local fc=fg:GetFirst()
	while fc do
		eg:Merge(fc:GetEquipGroup():Filter(Card.IsControler,nil,tp))
		fc=fg:GetNext()
	end
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		local sg=Group.CreateGroup()
		if f1(gc) then sg:Merge(g:Filter(f2,gc)) end
		if f2(gc) then sg:Merge(g:Filter(f1,gc)) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(aux.FConditionFilterF2c,nil,f1,f2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	sg:RemoveCard(tc1)
	local b1=f1(tc1)
	local b2=f2(tc1)
	if b1 and not b2 then sg:Remove(aux.FConditionFilterF2r,nil,f1,f2) end
	if b2 and not b1 then sg:Remove(aux.FConditionFilterF2r,nil,f2,f1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c66652260.mat_fil(c)
	return c:GetPreviousLocation()==LOCATION_EXTRA
end
function c66652260.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c66652260.atkcon(e)
	return e:GetHandler():GetFlagEffect(66652260+2)~=0
end
function c66652260.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c66652260.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(66652260+2)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(66652260+2,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c66652260.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c66652260.costfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToDeckAsCost()
end
function c66652260.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66652260.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c66652260.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c66652260.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c66652260.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end