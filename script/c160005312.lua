--Skull Mail Winda
function c160005312.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,160008957,54455435,true,true)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160005312,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,160005312)
	e1:SetCondition(c160005312.condition)
	e1:SetTarget(c160005312.target)
	e1:SetOperation(c160005312.operation)
	c:RegisterEffect(e1)
end
function c160005312.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c160005312.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc81)
end
function c160005312.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c160005312.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160005312.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c160005312.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_OATH)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c160005312.ftarget)
	e2:SetLabel(g:GetFirst():GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c160005312.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=Duel.GetMatchingGroupCount(c160005312.filter,tp,LOCATION_GRAVE,0,nil)*300
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c160005312.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
