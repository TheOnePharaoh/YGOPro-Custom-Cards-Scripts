--Vocaloid Marie and Luise
function c61815720.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61815720,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c61815720.cost)
	e1:SetOperation(c61815720.operation)
	c:RegisterEffect(e1)
	--Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61815720,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c61815720.cdspsum)
	e2:SetTarget(c61815720.tgspsum)
	e2:SetOperation(c61815720.opspsum)
	c:RegisterEffect(e2)
end
function c61815720.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelBelow(8) and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and not c:IsCode(61815720) and c:IsAbleToRemoveAsCost()
end
function c61815720.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c61815720.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c61815720.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c61815720.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(61815720,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(c61815720.rstop)
		c:RegisterEffect(e2)
	end
end
function c61815720.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c61815720.cdspsum(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c61815720.tgspsum(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp)
		and chkc:IsCanBeSpecialSummoned(e,0,PLAYER_NONE,false,false,POS_FACEUP,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_REMOVED,0,1,1,nil,e,0,PLAYER_NONE,false,false,POS_FACEUP,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c61815720.opspsum(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
