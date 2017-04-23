--Lucy
function c20912291.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3,c20912291.ovfilter,aux.Stringid(20912291,0))
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912291,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG2_XMDETACH)
	e1:SetCountLimit(1,20912291)
	e1:SetCondition(c20912291.copycon)
	e1:SetTarget(c20912291.copytg)
	e1:SetOperation(c20912291.copyop)
	c:RegisterEffect(e1)
end
function c20912291.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0 and not c:IsCode(20912291)
end
function c20912291.copycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0xd0a2)
end
function c20912291.filter(c)
	return c:IsSetCard(0xd0a2) and c:IsType(TYPE_XYZ) and not c:IsCode(20912291)
end
function c20912291.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c20912291.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912291.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c20912291.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c20912291.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetLabel(tp)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(20912291,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c20912291.rstcon)
		e2:SetOperation(c20912291.rstop)
		e2:SetLabel(cid)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
	end
end
function c20912291.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	return Duel.GetTurnPlayer()~=e1:GetLabel()
end
function c20912291.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
