--May-Raias Dark Cerberus
function c87002921.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c87002921.fscon)
	e0:SetOperation(c87002921.fsop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87002921,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c87002921.thcon)
	e2:SetCost(c87002921.thcost)
	e2:SetTarget(c87002921.thtg)
	e2:SetOperation(c87002921.thop)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c87002921.aclimit)
	e3:SetCondition(c87002921.actcon)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,87002921)
	e4:SetCondition(c87002921.descon)
	e4:SetTarget(c87002921.destg)
	e4:SetOperation(c87002921.desop)
	c:RegisterEffect(e4)
end
function c87002921.filter1(c)
	return ((c:IsType(TYPE_MONSTER) and c:IsFusionSetCard(0xe291ca)) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c87002921.filter2(c)
	return ((c:IsType(TYPE_MONSTER) and c:IsFusionAttribute(ATTRIBUTE_DARK)) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c87002921.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=c87002921.filter1
	local f2=c87002921.filter2
	local chkf=bit.band(chkfnf,0xff)
	local tp=e:GetHandlerPlayer()
	local fg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,87002923)
	local fc=fg:GetFirst()
	while fc do
		g:Merge(fc:GetEquipGroup():Filter(Card.IsControler,nil,tp))
		fc=fg:GetNext()
	end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	local mg1=mg:Filter(aux.FConditionFilterConAndSub,nil,f1,true)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
		return aux.FConditionFilterFFRCol1(gc,f1,f2,2,chkf,mg,nil,0) 
			or mg1:IsExists(aux.FConditionFilterFFRCol1,1,nil,f1,f2,2,chkf,mg,nil,0,gc)
	end
	return mg1:IsExists(Auxiliary.FConditionFilterFFRCol1,1,nil,f1,f2,2,chkf,mg,nil,0)
end
function c87002921.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=c87002921.filter1
	local f2=c87002921.filter2
	local chkf=bit.band(chkfnf,0xff)
	local fg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,87002923)
	local fc=fg:GetFirst()
	while fc do
		eg:Merge(fc:GetEquipGroup():Filter(Card.IsControler,nil,tp))
		fc=fg:GetNext()
	end
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	local mg1=g:Filter(aux.FConditionFilterConAndSub,nil,f1,true)
	local p=tp
	local sfhchk=false
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	if gc then
		local matg=Group.CreateGroup()
		if aux.FConditionFilterFFRCol1(gc,f1,f2,2,chkf,g,nil,0) then
			matg:AddCard(gc)
			for i=1,2 do
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
				local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,i-1)
				matg:Merge(g1)
				g:Sub(g1)
			end
			matg:RemoveCard(gc)
			if sfhchk then Duel.ShuffleHand(tp) end
			Duel.SetFusionMaterial(matg)
		else
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
			local matg=mg1:FilterSelect(p,aux.FConditionFilterFFRCol1,1,1,nil,f1,f2,2,chkf,g,nil,0,gc)
			matg:AddCard(gc)
			g:Sub(matg)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
			local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,1)
			matg:Merge(g1)
			g:Sub(g1)
			matg:RemoveCard(gc)
			if sfhchk then Duel.ShuffleHand(tp) end
			Duel.SetFusionMaterial(matg)
		end
		return
	end
	local matg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local matg=mg1:FilterSelect(p,aux.FConditionFilterFFRCol1,1,1,nil,f1,f2,2,chkf,g,nil,0,gc)
	g:Sub(matg)
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local g1=g:FilterSelect(p,aux.FConditionFilterFFRCol2,1,1,nil,f1,f2,2,chkf,g,matg,i-1)
		matg:Merge(g1)
		g:Sub(g1)
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(matg)
end
function c87002921.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c87002921.cofilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe291ca) and c:GetCode()~=87002902 and c:IsAbleToGraveAsCost()
end
function c87002921.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87002921.cofilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c87002921.cofilter,tp,LOCATION_DECK,0,1,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c87002921.thfilter(c)
	return c:GetCode()==87002901 and c:IsAbleToHand()
end
function c87002921.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87002921.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c87002921.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c87002921.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c87002921.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c87002921.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe291ca) and c:IsControler(tp)
end
function c87002921.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c87002921.cfilter(a,tp)) or (d and c87002921.cfilter(d,tp))
end
function c87002921.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp~=tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp)
end
function c87002921.exfilter(c)
	return not c:IsCode(87002901)
end
function c87002921.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87002921.exfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c87002921.exfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c87002921.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c87002921.exfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end