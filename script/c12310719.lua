--Darkwraith Knight
--lua script by SGJin
function c12310719.initial_effect(c)
	-- Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12310719.spcon)
	c:RegisterEffect(e1)
	--Search for Humanity
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12310719,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetTarget(c12310719.thtg)
	e2:SetOperation(c12310719.thop)
	c:RegisterEffect(e2)
end
function c12310719.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,1,nil,12310712)
end
function c12310719.filter(c)
	return c:IsCode(12310712) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310719.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310719.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12310719.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310719.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
