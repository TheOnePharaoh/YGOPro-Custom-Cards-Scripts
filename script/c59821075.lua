--Monna
function c59821075.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821075.splimit)
	e2:SetCondition(c59821075.splimcon)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-200)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,59821075)
	e4:SetCost(c59821075.cost)
	e4:SetTarget(c59821075.target)
	e4:SetOperation(c59821075.operation)
	c:RegisterEffect(e4)
	--destroy and set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(59821075,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCountLimit(1)
	e5:SetCondition(c59821075.setcon)
	e5:SetCost(c59821075.setcost)
	e5:SetTarget(c59821075.settg)
	e5:SetOperation(c59821075.setop)
	c:RegisterEffect(e5)
end
function c59821075.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821075.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c59821075.filter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c59821075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821075.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c59821075.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c59821075.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c59821075.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821075.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c59821075.desfilter1(c)
	return c:GetSequence()<5 and c:IsDestructable()
end
function c59821075.desfilter2(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c59821075.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c59821075.desfilter1,tp,0,LOCATION_SZONE,1,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c59821075.desfilter2,tp,0,LOCATION_SZONE,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(59821075,1),aux.Stringid(59821075,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(59821075,1))
	else
		Duel.SelectOption(tp,aux.Stringid(59821075,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		local g=Duel.GetMatchingGroup(c59821075.desfilter1,tp,0,LOCATION_SZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		local g=Duel.GetMatchingGroup(c59821075.desfilter2,tp,0,LOCATION_SZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c59821075.setop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c59821075.desfilter1,tp,0,LOCATION_SZONE,1,1,nil)
		local tc=g:GetFirst()
		if not tc then return end
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and not tc:IsLocation(LOCATION_HAND+LOCATION_DECK)
			and tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable()
			and Duel.SelectYesNo(tp,aux.Stringid(59821075,3)) then
			Duel.BreakEffect()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c59821075.desfilter2,tp,0,LOCATION_SZONE,1,1,nil)
		local tc=g:GetFirst()
		if not tc then return end
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0
			and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
			and not tc:IsLocation(LOCATION_HAND+LOCATION_DECK)
			and Duel.SelectYesNo(tp,aux.Stringid(59821075,4)) then
			Duel.BreakEffect()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
