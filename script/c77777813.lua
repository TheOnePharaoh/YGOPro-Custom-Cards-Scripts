--Requipped Warrior Beatrice
function c77777813.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(77777813,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,77777813)
	e1:SetCondition(c77777813.thcon)
	e1:SetTarget(c77777813.thtg)
	e1:SetOperation(c77777813.thop)
	c:RegisterEffect(e1)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777813,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777813.eqtg)
	e4:SetOperation(c77777813.eqop)
	c:RegisterEffect(e4)
end


function c77777813.eqfilter(c,ec)
	return c:IsSetCard(0x408) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c77777813.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--flag effect is set to allow the cards to be activated directly from the deck,
	--even though the monster is potentially already equipped with a Requipped card.
	e:GetHandler():RegisterFlagEffect(77777812,RESET_EVENT+0x1fe0000,0,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777813.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) 
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or e:GetHandler():GetEquipGroup():Filter(Card.IsControler,nil,tp):GetCount()>0) end
	e:GetHandler():ResetFlagEffect(77777812)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c77777813.eqop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetEquipGroup():GetCount()>0 then
		local g2=e:GetHandler():GetEquipGroup()
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408)then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c77777813.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
end

function c77777813.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(c77777813.filter,1,e:GetHandler())
end

function c77777813.filter(c)
	return c:IsSetCard(0x408)and c:IsType(TYPE_SPELL)and c:IsType(TYPE_EQUIP)
end
function c77777813.filter2(c)
	return c:IsSetCard(0x408) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777813.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77777813.filter2,tp,LOCATION_DECK,0,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777813.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=e:GetHandler():GetEquipGroup()
	local count=g2:GetCount()
	if count>0 and Duel.SendtoGrave(g2,REASON_EFFECT)==count then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c77777813.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end