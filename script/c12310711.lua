--Lifehunt Scythe
--lua script by SGJin
function c12310711.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c12310711.target)
	e1:SetOperation(c12310711.operation)
	c:RegisterEffect(e1)
	--ATK up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--Self bleed effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c12310711.mtop)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310711,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c12310711.thcon)
	e4:SetTarget(c12310711.thtg)
	e4:SetOperation(c12310711.thop)
	c:RegisterEffect(e4)
	--Equip limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c12310711.eqlimit)
	c:RegisterEffect(e5)
end
function c12310711.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c12310711.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c12310711.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12310711.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310711.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12310711.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12310711.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c12310711.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()~=tp then return end
	if c:GetEquipTarget():IsCode(12310707) then
		return 
	else
		if Duel.GetLP(tp)>1200 and Duel.SelectYesNo(tp,aux.Stringid(82432018,0)) then
			Duel.PayLPCost(tp,1200)
		else
			Duel.Destroy(e:GetHandler(),REASON_RULE)
		end
	end
end
function c12310711.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c12310711.filter2(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310711.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310711.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12310711.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310711.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
