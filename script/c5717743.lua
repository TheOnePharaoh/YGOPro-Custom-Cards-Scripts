--Vocaloid Hagane Miku
function c5717743.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x0dac402),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5717743,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c5717743.destg)
	e1:SetOperation(c5717743.desop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c5717743.efilter)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5717743,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c5717743.copytg)
	e3:SetOperation(c5717743.copyop)
	c:RegisterEffect(e3)
end
function c5717743.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and not tc:IsRace(RACE_MACHINE) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c5717743.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c5717743.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c5717743.copyfilter(c)
	return (c:IsSetCard(0x0dac402)) and c:IsType(TYPE_SYNCHRO)
		and not c:IsHasEffect(EFFECT_FORBIDDEN) and c:IsAbleToRemove() and not c:IsCode(5717743)
end
function c5717743.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c5717743.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5717743.copyfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c5717743.copyfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c5717743.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then	return end
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(5717743,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetLabel(cid)
		e2:SetOperation(c5717743.rstop)
		c:RegisterEffect(e2)
	end
end
function c5717743.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
