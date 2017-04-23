--Vocaloid Yuzuki Yukari Xracer
function c38299891.initial_effect(c)
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
	e2:SetCondition(c38299891.pcon1)
	e2:SetTarget(c38299891.ptg1)
	e2:SetOperation(c38299891.pop1)
	c:RegisterEffect(e2)
	--atk change and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(38299891,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP,EFFECT_FLAG2_XMDETACH)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c38299891.atkcon)
	e3:SetCost(c38299891.atkcost)
	e3:SetTarget(c38299891.atktg)
	e3:SetOperation(c38299891.atkop)
	c:RegisterEffect(e3)
	--pendulum set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c38299891.pcon2)
	e4:SetTarget(c38299891.ptg2)
	e4:SetOperation(c38299891.pop2)
	c:RegisterEffect(e4)
end
c38299891.pendulum_level=5
function c38299891.pcon1(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil
end
function c38299891.pfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c38299891.ptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38299891.pfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c38299891.pop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=e:GetHandler():GetSequence()
	if Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)~=nil then return end
	local g=Duel.SelectMatchingCard(tp,c38299891.pfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c38299891.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_XYZ and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c38299891.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c38299891.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c38299891.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38299891.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c38299891.atkfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetCard(g)
end
function c38299891.atkfilter2(c,e)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c38299891.atkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c38299891.atkfilter2,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(38299891,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		tc=sg:GetNext()
	end
	sg:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(sg)
	e2:SetCondition(c38299891.descon)
	e2:SetOperation(c38299891.desop)
	Duel.RegisterEffect(e2,tp)
end
function c38299891.desfilter(c,fid)
	return c:GetFlagEffectLabel(38299891)==fid
end
function c38299891.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c38299891.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c38299891.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local dg=g:Filter(c38299891.desfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(dg,REASON_EFFECT)
end
function c38299891.pcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c38299891.pdfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c38299891.ptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38299891.pdfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c38299891.pdfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c38299891.pop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c38299891.pdfilter,tp,LOCATION_SZONE,0,nil)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
