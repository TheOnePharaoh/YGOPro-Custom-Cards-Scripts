--Hellformed Girl Lizbeth
function c77777764.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777764.splimit)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetDescription(aux.Stringid(77777764,1))
	e4:SetCondition(c77777764.thcon)
	e4:SetTarget(c77777764.thtg)
	e4:SetOperation(c77777764.thop)
	c:RegisterEffect(e4)
	--Search for S/T
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777764,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,77777764)
	e6:SetCost(c77777764.cost)
	e6:SetTarget(c77777764.target)
	e6:SetOperation(c77777764.operation)
	c:RegisterEffect(e6)
	--Special Summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetRange(LOCATION_HAND)
	e7:SetDescription(aux.Stringid(77777764,2))
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e7:SetTargetRange(POS_FACEUP,0)
	e7:SetCondition(c77777764.spcon2)
	c:RegisterEffect(e7)
end

function c77777764.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0x3e7) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0x3e7)
end
function c77777764.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_FIEND) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c77777764.thcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc
end
function c77777764.filter(c)
	return c:IsSetCard(0x3e7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777764.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	if chk==0 then return c:IsDestructable() and pc:IsDestructable()
		and Duel.IsExistingMatchingCard(c77777764.filter,tp,LOCATION_DECK,0,1,nil) end
	local g=Group.FromCards(c,pc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777764.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	if not pc then return end
	local dg=Group.FromCards(c,pc)
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777764.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c77777764.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e7) and c:IsDestructable() 
	and  (c:GetSequence()==6 or c:GetSequence()==7)
end
function c77777764.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777764.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c77777764.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end

function c77777764.thfilter(c)
	return c:IsSetCard(0x3e7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c77777764.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777764.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777764.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777764.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
