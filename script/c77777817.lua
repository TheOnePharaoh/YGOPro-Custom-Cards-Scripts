--Requipped Warrior Amadeus
function c77777817.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777817,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c77777817.spcon)
	e1:SetTarget(c77777817.sptg)
	e1:SetOperation(c77777817.spop)
	c:RegisterEffect(e1)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777817,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777817.eqtg)
	e4:SetOperation(c77777817.eqop)
	c:RegisterEffect(e4)
end


function c77777817.eqfilter(c,ec)
	return c:IsSetCard(0x408) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c77777817.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--flag effect is set to allow the cards to be activated directly from the deck,
	--even though the monster is potentially already equipped with a Requipped card.
	e:GetHandler():RegisterFlagEffect(77777812,RESET_EVENT+0x1fe0000,0,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777817.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) 
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or e:GetHandler():GetEquipGroup():Filter(Card.IsControler,nil,tp):GetCount()>0) end
	e:GetHandler():ResetFlagEffect(77777812)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c77777817.eqop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetEquipGroup():GetCount()>0 then
		local g2=e:GetHandler():GetEquipGroup()
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408)then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c77777817.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
end

function c77777817.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c77777817.spfil(c,e,tp)
	return c:IsSetCard(0x408) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)and not c:IsCode(77777817)
end
function c77777817.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c77777817.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77777817.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777817.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end