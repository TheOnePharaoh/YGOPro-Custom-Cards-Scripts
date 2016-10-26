--Requipped Arms - Demon Sword
function c77777825.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c77777825.target)
	e1:SetOperation(c77777825.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c77777825.eqlimit)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777825,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,77777825)
	e4:SetTarget(c77777825.destg)
	e4:SetOperation(c77777825.desop)
	c:RegisterEffect(e4)
	--shuffle into deck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(c77777825.tdtg)
	e5:SetOperation(c77777825.tdop)
	c:RegisterEffect(e5)
	--def up
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetValue(500)
	c:RegisterEffect(e6)
end
function c77777825.eqlimit(e,c)
	return c:IsSetCard(0x408) and (c:GetFlagEffect(77777812)~=0 or not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408) or c:IsType(TYPE_XYZ))
end
function c77777825.filter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x408)  and (not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408)or c:IsType(TYPE_XYZ))
end
function c77777825.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c77777825.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777825.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77777825.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77777825.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() 
		and (tc:IsType(TYPE_XYZ) or not tc:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x408))then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end


function c77777825.tdfilter(c)
	return c:IsSetCard(0x408) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsAbleToDeck()
end
function c77777825.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c77777825.tdfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c77777825.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c77777825.tdfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	local g2=Group.FromCards(c)
	g1:Merge(g2)
	if g1:GetCount()==3 then
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	end
end

function c77777825.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c77777825.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c77777825.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777825.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77777825.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77777825.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
