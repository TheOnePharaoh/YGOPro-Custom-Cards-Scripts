--Vocaloid Yuzuki Yukari Xracer
function c38299892.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),5,3)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c38299892.pcon1)
	e2:SetTarget(c38299892.ptg1)
	e2:SetOperation(c38299892.pop1)
	c:RegisterEffect(e2)
	--atk twice
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(38299892,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG2_XMDETACH)
	e3:SetCondition(c38299892.atkcon)
	e3:SetCost(c38299892.atkcost)
	e3:SetTarget(c38299892.atktg)
	e3:SetOperation(c38299892.atkop)
	c:RegisterEffect(e3)
	--pendulum set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c38299892.pcon2)
	e4:SetTarget(c38299892.ptg2)
	e4:SetOperation(c38299892.pop2)
	c:RegisterEffect(e4)
end
c38299892.pendulum_level=5
function c38299892.pcon1(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil
end
function c38299892.pfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c38299892.ptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38299892.pfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c38299892.pop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=e:GetHandler():GetSequence()
	if Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)~=nil then return end
	local g=Duel.SelectMatchingCard(tp,c38299892.pfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c38299892.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_XYZ and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c38299892.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c38299892.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c38299892.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c38299892.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c38299892.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c38299892.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c38299892.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c38299892.pcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c38299892.pdfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c38299892.ptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38299892.pdfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c38299892.pdfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c38299892.pop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c38299891.pdfilter,tp,LOCATION_SZONE,0,nil)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
