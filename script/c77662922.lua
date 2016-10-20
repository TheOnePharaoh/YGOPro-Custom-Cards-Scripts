--Nijiiro Chouchou - Song of Regret and Fear
function c77662922.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c77662922.tg)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
	--def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c77662922.tg)
	e3:SetValue(-500)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c77662922.tg)
	c:RegisterEffect(e4)
	--material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77662922,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetTarget(c77662922.mattg)
	e5:SetOperation(c77662922.matop)
	c:RegisterEffect(e5)
	--salvage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77662922,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c77662922.thcon)
	e6:SetTarget(c77662922.thtg)
	e6:SetOperation(c77662922.thop)
	c:RegisterEffect(e6)
end
function c77662922.tg(e,c)
	return not c:IsType(TYPE_XYZ)
end
function c77662922.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac404) and c:IsType(TYPE_XYZ) and not c:IsCode(990815)
end
function c77662922.matfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevelBelow(6) and not c:IsType(TYPE_TOKEN)
end
function c77662922.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c77662922.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77662922.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c77662922.matfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77662922.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77662922.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c77662922.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c77662922.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c77662922.thfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac404) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeEffectTarget(e)
end
function c77662922.thfilter2(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c77662922.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c77662922.thfilter(chkc,e) end
	local g=Duel.GetMatchingGroup(c77662922.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:FilterSelect(tp,c77662922.thfilter2,1,1,nil,g)
	if g1:GetCount()>0 then
		local g2=g:FilterSelect(tp,Card.IsCode,1,1,g1:GetFirst(),g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SetTargetCard(g1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
	end
end
function c77662922.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
