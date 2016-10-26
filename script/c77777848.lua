--Mystic Fauna Owl
function c77777848.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777848,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77777848.spcon)
	c:RegisterEffect(e1)
  --search on shuffle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777848,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e3:SetCountLimit(1,77777848)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetTarget(c77777848.tg)
	e3:SetOperation(c77777848.op)
	c:RegisterEffect(e3)
end

function c77777848.filter2(c)
	return c:IsSetCard(0x40a) and c:IsType(TYPE_MONSTER)and c:IsAbleToHand() 
    and not c:IsCode(77777848)
end
function c77777848.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777848.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and re:GetOwner():IsSetCard(0x40a)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77777848.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777848.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c77777848.filter(c)
	return c:IsRace(RACE_BEAST)and (c:IsLevelBelow(2) or c:IsRankBelow(2))and c:IsFaceup()
end

function c77777848.spcon(e,c)
	if c==nil then return true end
  local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777848.filter,tp,LOCATION_MZONE,0,1,nil)
end