--ANTI-MATTER Dark Being, Zoht
function c1143223.initial_effect(c)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c1143223.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143223,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c1143223.drcost)
	e4:SetTarget(c1143223.drtg)
	e4:SetOperation(c1143223.drop)
	c:RegisterEffect(e4)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1143223,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,1143223)
	e5:SetTarget(c1143223.thtg)
	e5:SetOperation(c1143223.thop)
	c:RegisterEffect(e5)
	if not c1143223.global_check then
		c1143223.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143223))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143223.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c1143223.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e:GetHandler():RegisterEffect(e1)
end
function c1143223.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
function c1143223.costfilter(c)
	return c:IsSetCard(0xaf75) and c:IsAbleToRemoveAsCost()
end
function c1143223.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143223.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1143223.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1143223.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c1143223.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1143223.thfilter(c)
	return c:IsSetCard(0xaf75) and c:IsAbleToHand()
end
function c1143223.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK+LOCATION_REMOVED) and chkc:IsControler(tp) and c1143223.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143223.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c1143223.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c1143223.sumfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and not c:IsCode(1143223) and c:IsSummonable(true,nil)
end
function c1143223.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c1143223.sumfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			end
	end
end