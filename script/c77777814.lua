--Requipped Warrior Elyssa
function c77777814.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,77777814)
	e1:SetCondition(c77777814.spcon)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c77777814.atcon)
	c:RegisterEffect(e2)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777814,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777814.eqtg)
	e4:SetOperation(c77777814.eqop)
	c:RegisterEffect(e4)
end

function c77777814.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c77777814.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c77777814.eqfilter(c,ec)
	return c:IsSetCard(0x408) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c77777814.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--flag effect is set to allow the cards to be activated directly from the deck,
	--even though the monster is potentially already equipped with a Requipped card.
	e:GetHandler():RegisterFlagEffect(77777812,RESET_EVENT+0x1fe0000,0,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777814.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) 
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or e:GetHandler():GetEquipGroup():Filter(Card.IsControler,nil,tp):GetCount()>0) end
	e:GetHandler():ResetFlagEffect(77777812)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c77777814.eqop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetEquipGroup():GetCount()>0 then
		local g2=e:GetHandler():GetEquipGroup()
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408)then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c77777814.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
end

function c77777814.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c77777814.atcon(e)
	return not e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408)
end