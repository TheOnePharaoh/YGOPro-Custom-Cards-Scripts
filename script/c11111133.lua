--Vocaloid Jammer Device
function c11111133.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11111133)
	e1:SetCondition(c11111133.condition)
	e1:SetOperation(c11111133.activate)
	c:RegisterEffect(e1)
	--Destroy & Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111133,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11111133)
	e2:SetCost(c11111133.descost)
	e2:SetTarget(c11111133.destg)
	e2:SetOperation(c11111133.desop)
	c:RegisterEffect(e2)
end
function c11111133.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c11111133.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11111133.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11111133.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c11111133.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c11111133.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE)
end
function c11111133.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11111133.desfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM) and c:IsDestructable()
end
function c11111133.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11111133.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11111133.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11111133.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11111133.desop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
