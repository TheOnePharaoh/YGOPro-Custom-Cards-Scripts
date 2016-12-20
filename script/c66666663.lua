--Thysia, Archangel of Combustion
function c66666663.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1)
	c:EnableReviveLimit()
	--pendulum summon
    aux.EnablePendulumAttribute(c)
    --lv change
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c66666663.target)
	e1:SetOperation(c66666663.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666663,3))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c66666663.destg)
	e2:SetOperation(c66666663.desop)
	c:RegisterEffect(e2)
	--PS limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c66666663.splimit)
	c:RegisterEffect(e3)
	--Pendulum Place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66666663,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c66666663.pcon)
	e5:SetOperation(c66666663.pop)
	c:RegisterEffect(e5)
end
function c66666663.tgfilter(c)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
	end
end
function c66666663.desfilter(c)
	return c66666663.tgfilter(c) and c:IsDestructable()
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,0,LOCATION_ONFIELD,0,1,c)
end
function c66666663.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c66666663.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666663.desfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c66666663.desfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
end
function c66666663.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function c66666663.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x29b) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c66666663.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c66666663.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66666663.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666663.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c66666663.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(66666663,0))
	else op=Duel.SelectOption(tp,aux.Stringid(66666663,0),aux.Stringid(66666663,1)) end
	e:SetLabel(op)
end
function c66666663.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end

function c66666663.pcon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7))
end
function c66666663.pop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)) then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

